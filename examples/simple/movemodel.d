/+ Моделирование движения материальной точки под действием сил
    
   сборка и запуск
       
       rdmd movemodel.d vector.d
 +/

import vector : Vec2;

// состояние системы на момент времени
struct State
{
    Vec2 pos, vel;
    float time;
}

// модель расчитывает силу (ускорение при единичной массе) от состояния
alias Model = Vec2 delegate(ref const State);

// абстракция метода интегрирования, меняющая исходное состояние
alias Integrator = void delegate(ref State, Model, float dt);

// интегрирование по Эйлеру
void euler(ref State s, Model model, float dt)
{
    auto acc = model(s);
    with (s)
    {
        pos += vel * dt;
        vel += acc * dt;
        time += dt;
    }
}

void main()
{
    // локальные импорты иногда ускоряют сборку и не засоряют
    // пространство имён, являются хорошим тоном
    import std.stdio : writeln;
    import std.algorithm : each;
    import std.range : take;
    import std.functional : toDelegate;

    // начальное состояние системы
    auto initial = State(Vec2(0, 10), Vec2(5, 0), 0);

    // превратим заранее функцию в делегат для удобства
    auto edg = toDelegate(&euler);

    // симуляция вращения вокруг центра масс
    auto sim1 = simulator(initial, toDelegate(&centerMass), edg, 10, 0.01);
    // берём первые 30 значений симуляции и выводим по измерению на строку
    sim1.take(30).each!writeln;

    writeln();

    // постоянное линейное ускорение
    auto lineAcc = LineAcc(Vec2(0, -9.81));

    auto sim2 = simulator(initial, &lineAcc.model, edg, 10, 0.01);
    sim2.take(20).each!writeln;

    writeln();

    auto distLim = DistLim(Vec2(0, 10), 10, 100);

    auto friction = Friction(0.2);

    auto sim3model = modelSum(&lineAcc.model, // берём линейное ускорение
                              &distLim.model, // берём ограничение по длине от точки
                              &friction.model); // добавляем трение

    auto sim3 = simulator(initial, sim3model, edg, 10, 0.1);

    sim3.take(200).each!writeln;
}

Vec2 centerMass(ref const State s)
{
    const center = Vec2(0,0);
    const fk = 100;
    auto d = center - s.pos;
    return d * fk / d.len2;
}

struct LineAcc
{
    Vec2 acc;
    Vec2 model(ref const State s) { return acc; }
}

// ограничение на расстояние от точки (верёвка)
struct DistLim
{
    Vec2 pos;
    float dist, k;

    Vec2 model(ref const State s)
    {
        import std.math : abs;
        auto d = pos - s.pos;
        if (dist < d.len)
            return d/d.len * k * (d.len - dist);
        else
            return Vec2(0,0);
    }
}

// трение воздуха
struct Friction
{
    // Cx0 * rho * S / 2
    float k = 0.5;
    Vec2 model(ref const State s) { return -s.vel * s.vel.len * k; }
}

// расчёт суперпозиции сил
auto modelSum(Model[] funcs...)
{
    return (ref const State s)
    {
        auto res = Vec2(0,0);
        foreach (f; funcs)
            res += f(s);
        return res;
    };
}

auto simulator(State initial, Model model, Integrator integ, float time, float step)
{
    struct Result
    {
        State front; Model mdl; Integrator integ; float rest, dt;

        bool empty() const @property { return rest < 0; }

        void popFront()
        {
            integ(front, mdl, dt);
            rest -= dt;
        }
    }

    return Result(initial, model, integ, time, step);
}