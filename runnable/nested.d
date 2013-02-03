// REQUIRED_ARGS:

import std.c.stdio;

/*******************************************/

int bar(int a)
{
    int foo(int b) { return b + 1; }

    return foo(a);
}

void test1()
{
    assert(bar(3) == 4);
}

/*******************************************/

int bar2(int a)
{
    static int c = 4;

    int foo(int b) { return b + c + 1; }

    return foo(a);
}

void test2()
{
    assert(bar2(3) == 8);
}


/*******************************************/

int bar3(int a)
{
    static int foo(int b) { return b + 1; }

    return foo(a);
}

void test3()
{
    assert(bar3(3) == 4);
}

/*******************************************/

int bar4(int a)
{
    static int c = 4;

    static int foo(int b) { return b + c + 1; }

    return foo(a);
}

void test4()
{
    assert(bar4(3) == 8);
}


/*******************************************/

int bar5(int a)
{
    int c = 4;

    int foo(int b) { return b + c + 1; }

    return c + foo(a);
}

void test5()
{
    assert(bar5(3) == 12);
}


/*******************************************/

int bar6(int a)
{
    int c = 4;

    int foob(int b) { return b + c + 1; }
    int fooa(int b) { return foob(c + b) * 7; }

    return fooa(a);
}

void test6()
{
    assert(bar6(3) == 84);
}


/*******************************************/

int bar7(int a)
{
    static int c = 4;

    static int foob(int b) { return b + c + 1; }

    int function(int) fp = &foob;

    return fp(a);
}

void test7()
{
    assert(bar7(3) == 8);
}

/*******************************************/

int bar8(int a)
{
    int c = 4;

    int foob(int b) { return b + c + 1; }

    int delegate(int) fp = &foob;

    return fp(a);
}

void test8()
{
    assert(bar8(3) == 8);
}


/*******************************************/

struct Abc9
{
    int a;
    int b;
    int c = 7;

    int bar(int x)
    {
        Abc9 *foo() { return &this; }

        Abc9 *p = foo();
        assert(p == &this);
        return p.c + x;
    }
}

void test9()
{
    Abc9 x;

    assert(x.bar(3) == 10);
}

/*******************************************/

class Abc10
{
    int a;
    int b;
    int c = 7;

    int bar(int x)
    {
        Abc10 foo() { return this; }

        Abc10 p = foo();
        assert(p == this);
        return p.c + x;
    }

}

void test10()
{
    Abc10 x = new Abc10();

    assert(x.bar(3) == 10);
}


/*******************************************/

class Collection
{
    int[3] array;

    void opApply(void delegate(int) fp)
    {
        for (int i = 0; i < array.length; i++)
            fp(array[i]);
    }
}

int func11(Collection c)
{
    int max = int.min;

    void comp_max(int i)
    {
        if (i > max)
            max = i;
    }

    c.opApply(&comp_max);
    return max;
}

void test11()
{
    Collection c = new Collection();

    c.array[0] = 7;
    c.array[1] = 26;
    c.array[2] = 25;

    int m = func11(c);
    assert(m == 26);
}


/*******************************************/

void SimpleNestedFunction ()
{
    int nest () { return 432; }

    assert (nest () == 432);
    int delegate () func = &nest;
    assert (func () == 432);
}

void AccessParentScope ()
{
    int value = 9;

    int nest () { assert (value == 9); return 9; }

    assert (nest () == 9);
}

void CrossNestedScope ()
{
    int x = 45;

    void foo () { assert (x == 45); }
    void bar () { int z = 16; foo (); }
    bar ();
}

void BadMultipleNested ()
{
    int x;

    void foo ()
    {
       void bar ()
       {
           //erroneous x = 4; // Should fail.
       }
    }
}

/* This one kind of depends upon memory layout.  GlobalScopeSpoof should
be called with no "this" pointer; this is trying to ensure that
everything is working properly.  Of course, in the DMD calling
convention it'll fail if the caller passes too much/little data. */

void GlobalScopeSpoof (int x, int y)
{
    assert (x == y && y == 487);
}

void GlobalScope ()
{
    void bar () { GlobalScopeSpoof (487, 487); }
    bar ();
}

class TestClass
{
    int x = 6400;

    void foo ()
    {
       void bar () { assert (x == 6400); }
       bar ();
    }
}

void test12()
{
    SimpleNestedFunction ();
    AccessParentScope ();
    CrossNestedScope ();
    GlobalScope ();
    (new TestClass).foo ();
}


/*******************************************/

void test13()
{
    struct Abc
    {
        int x = 3;
        int y = 4;
    }

    Abc a;

    assert(a.x == 3 && a.y == 4);
}


/*******************************************/

void test14()
{
    struct Abc
    {
        int x = 3;
        int y = 4;

        int foo() { return y; }
    }

    Abc a;

    assert(a.foo() == 4);
}


/*******************************************/

void test15()
{
    static int z = 5;

    struct Abc
    {
        int x = 3;
        int y = 4;

        int foo() { return y + z; }
    }

    Abc a;

    assert(a.foo() == 9);
}


/*******************************************/

void test16()
{
    static int z = 5;

    static class Abc
    {
        int x = 3;
        int y = 4;

        int foo() { return y + z; }
    }

    Abc a = new Abc();

    assert(a.foo() == 9);
}


/*******************************************/

void test17()
{
    int function(int x) fp;

    fp = function int(int y) { return y + 3; };
    assert(fp(7) == 10);
}

/*******************************************/

void test18()
{
    static int a = 3;
    int function(int x) fp;

    fp = function int(int y) { return y + a; };
    assert(fp(7) == 10);
}

/*******************************************/

void test19()
{
    int a = 3;

    int delegate(int x) fp;

    fp = delegate int(int y) { return y + a; };
    assert(fp(7) == 10);
}


/*******************************************/

class Collection20
{
    int[3] array;

    void opApply(void delegate(int) fp)
    {
        for (int i = 0; i < array.length; i++)
            fp(array[i]);
    }
}

int func20(Collection20 c)
{
    int max = int.min;

    c.opApply(delegate(int i) { if (i > max) max = i; });
    return max;
}

void test20()
{
    Collection20 c = new Collection20();

    c.array[0] = 7;
    c.array[1] = 26;
    c.array[2] = 25;

    int m = func20(c);
    assert(m == 26);
}


/*******************************************/

int bar21(int a)
{
    int c = 3;

    int foo(int b)
    {
        b += c;         // 4 is added to b
        c++;            // bar.c is now 5
        return b + c;   // 12 is returned
    }
    c = 4;
    int i = foo(a);     // i is set to 12
    return i + c;       // returns 17
}

void test21()
{
    int i = bar21(3);   // i is assigned 17
    assert(i == 17);
}

/*******************************************/

void foo22(void delegate() baz)
{
  baz();
}

void bar22(int i)
{
  int j = 14;
  printf("%d,%d\n",i,j);

  void fred()
  {
    printf("%d,%d\n",i,j);
    assert(i == 12 && j == 14);
  }

  fred();
  foo22(&fred);
}

void test22()
{
  bar22(12);
}


/*******************************************/

void frelled(void delegate() baz)
{
  baz();
}

class Foo23
{
  void bar(int i)
  {
    int j = 14;
    printf("%d,%d\n",i,j);

    void fred()
    {
        printf("%d,%d\n",i,j);
        assert(i == 12);
        assert(j == 14);
    }

    frelled(&fred);
  }
}

void test23()
{
    Foo23 f = new Foo23();

    f.bar(12);
}


/*******************************************/

void delegate () function (int x) store24;

void delegate () zoom24(int x)
{
   return delegate void () { };
}

void test24()
{
   store24 = &zoom24;
   store24 (1) ();
}


/*******************************************/

void test25()
{
    delegate() { printf("stop the insanity!\n"); }();
    delegate() { printf("stop the insanity! 2\n"); }();
}

/*******************************************/

alias bool delegate(int) callback26;


bool foo26(callback26 a)
{
    return a(12);
}

class Bar26
{
    int func(int v)
    {
        printf("func(v=%d)\n", v);
        foo26(delegate bool(int a)
        {
            printf("%d %d\n",a,v); return true;
            assert(a == 12);
            assert(v == 15);
            assert(0);
        } );
        return v;
    }
}


void test26()
{
    Bar26 b = new Bar26();

    b.func(15);
}


/*******************************************/

class A27
{
    uint myFunc()
    {
        uint myInt = 13;
        uint mySubFunc()
        {
            return myInt;
        }
        return mySubFunc();
    }
}

void test27()
{
    A27 myInstance = new A27;
    int i = myInstance.myFunc();
    printf("%d\n", i);
    assert(i == 13);
}


/*******************************************/

void Foo28(void delegate() call)
{
    call();
}

class Bar28
{
    int func()
    {
        int count = 0;

        Foo28(delegate void() { ++count; } );
        return count;
    }
}

void test28()
{
    Bar28 b = new Bar28();
    int i = b.func();
    assert(i == 1);
}


/*******************************************/

class Foo29
{
  void Func(void delegate() call)
  {
    for(int i = 0; i < 10; ++i)
      call();
  }
}

class Bar29
{
    int Func()
    {
        int count = 0;
        Foo29 ic = new Foo29();

        ic.Func(delegate void() { ++count; } );
        return count;
    }
}

void test29()
{
    Bar29 b = new Bar29();
    int i = b.Func();
    assert(i == 10);
}

/*******************************************/

struct Foo30
{
  int[] arr;
}

void Func30(Foo30 bar)
{
    void InnerFunc(int x, int y)
    {
        int a = bar.arr[y]; // Ok

        if(bar.arr[y]) // Access violation
        {
        }
    }

    InnerFunc(5,5);
}


void test30()
{
  Foo30 abc;

  abc.arr.length = 10;
  Func30(abc);
}


/*******************************************/

void call31(int d, void delegate(int d) f)
{
    assert(d == 100 || d == 200);
    printf("d = %d\n", d);
    f(d);
}

void test31()
{
    call31(100, delegate void(int d1)
    {
        printf("d1 = %d\n", d1);
        assert(d1 == 100);
        call31(200, delegate void(int d2)
        {
            printf("d1 = %d\n", d1);
            printf("d2 = %d\n", d2);
            assert(d1 == 100);
            assert(d2 == 200);
        });
    });
}


/*******************************************/

void call32(int d, void delegate(int d) f)
{
    assert(d == 100 || d == 200);
    printf("d = %d\n", d);
    f(d);
}

void test32()
{
    call32(100, delegate void(int d1)
    {
        int a = 3;
        int b = 4;
        printf("d1 = %d, a = %d, b = %d\n", d1, a, b);
        assert(a == 3);
        assert(b == 4);
        assert(d1 == 100);

        call32(200, delegate void(int d2)
        {
            printf("d1 = %d, a = %d\n", d1, a);
            printf("d2 = %d, b = %d\n", d2, b);
            assert(a == 3);
            assert(b == 4);
            assert(d1 == 100);
            assert(d2 == 200);
        });
    });
}


/*******************************************/

void test33()
{
    extern (C) int Foo1(int a, int b, int c)
    {
        assert(a == 1);
        assert(b == 2);
        assert(c == 3);
        return 1;
    }

    extern (D) int Foo2(int a, int b, int c)
    {
        assert(a == 1);
        assert(b == 2);
        assert(c == 3);
        return 2;
    }

    extern (Windows) int Foo3(int a, int b, int c)
    {
        assert(a == 1);
        assert(b == 2);
        assert(c == 3);
        return 3;
    }

    extern (Pascal) int Foo4(int a, int b, int c)
    {
        assert(a == 1);
        assert(b == 2);
        assert(c == 3);
        return 4;
    }

    assert(Foo1(1, 2, 3) == 1);
    assert(Foo2(1, 2, 3) == 2);
    assert(Foo3(1, 2, 3) == 3);
    assert(Foo4(1, 2, 3) == 4);

    printf("test33 success\n");
}

/*******************************************/

class Foo34
{
    int x;

    class Bar
    {
        int y;

        int delegate() getDelegate()
        {
            assert(y == 8);
            auto i = sayHello();
            assert(i == 23);
            return &sayHello;
        }
    }
    Bar bar;

    int sayHello()
    {
        printf("Hello\n");
        assert(x == 47);
        return 23;
    }

    this()
    {
        x = 47;
        bar = new Bar();
        bar.y = 8;
    }
}

void test34()
{
    Foo34 foo = new Foo34();
    int delegate() saydg = foo.bar.getDelegate();
    printf("This should print Hello:\n");
    auto i = saydg();
    assert(i == 23);
}

/*******************************************/

class Foo35
{
    int x = 42;
    void bar()
    {
        int y = 43;
        new class Object
        {
            this()
            {
                //writefln("x = %s", x);
                //writefln("y = %s", y);
                assert(x == 42);
                assert(y == 43);
            }
        };
    }
}

void test35()
{
    Foo35 f = new Foo35();
    f.bar();
}

/*******************************************/

class Foo36
{
    int x = 42;
    this()
    {
        int y = 43;
        new class Object
        {
            this()
            {
                //writefln("x = %s", x);
                //writefln("y = %s", y);
                assert(x == 42);
                assert(y == 43);
            }
        };
    }
}

void test36()
{
    Foo36 f = new Foo36();
}

/*******************************************/

class Foo37
{
    int x = 42;
    void bar()
    {
        int y = 43;
        void abc()
        {
            new class Object
            {
                this()
                {
                    //writefln("x = %s", x);
                    //writefln("y = %s", y);
                    assert(x == 42);
                    assert(y == 43);
                }
            };
        }

        abc();
    }
}

void test37()
{
    Foo37 f = new Foo37();
    f.bar();
}

/*******************************************/

void test38()
{
    int status = 3;

    int delegate() foo()
    {
        class C
        {
            int dg()
            {
                return ++status;
            }
        }

        C c = new C();

        return &c.dg;
    }

    int delegate() bar = foo();

    if(status != 3)
    {
        assert(0);
    }

    if(bar() != 4)
    {
        assert(0);
    }

    if(status != 4)
    {
        assert(0);
    }
}

/*******************************************/

void test39()
{
    int status;

    int delegate() foo()
    {
        return &(new class
            {
                int dg()
                {
                    return ++status;
                }
            }
        ).dg;
    }

    int delegate() bar = foo();

    if(status != 0)
    {
        assert(0);
    }

    if(bar() != 1)
    {
        assert(0);
    }

    if(status != 1)
    {
        assert(0);
    }
}

/*******************************************/

interface I40
{
    void get( string s );
}

class C40
{
    int a = 4;

    void init()
    {
        I40 i = new class() I40
        {
            void get( string s )
            {
                func();
            }
        };
        i.get("hello");
    }
    void func( ){ assert(a == 4); }
}

void test40()
{
    C40 c = new C40();
    c.init();
}

/*******************************************/

class C41
{   int a = 3;

    void init()
    {
        class N
        {
            void get()
            {
                func();
            }
        }
        N n = new N();
        n.get();
    }
    void func()
    {
        assert(a == 3);
    }
}


void test41()
{
   C41 c = new C41();
   c.init();
}

/*******************************************/

class C42
{   int a = 3;

    void init()
    {
        class N
        {
            void init()
            {
                class M
                {
                    void get()
                    {
                        func();
                    }
                }
                M m = new M();
                m.get();
            }
        }
        N n = new N();
        n.init();
    }
    void func()
    {
        assert(a == 3);
    }
}

void test42()
{
   C42 c = new C42();
   c.init();
}


/*******************************************/

int foo43(alias X)() { return X; }

void test43()
{
    int x = 3;

    void bar()
    {
        int y = 4;
        assert(foo43!(x)() == 3);
        assert(foo43!(y)() == 4);
    }

    bar();

    assert(foo43!(x)() == 3);
}


/*******************************************/

class Comb
{
}

Comb Foo44(Comb delegate()[] c...)
{
    Comb ec = c[0]();
    printf("1ec = %p\n", ec);
    ec.toString();
    printf("2ec = %p\n", ec);
    return ec;
}

Comb c44;

static this()
{
    c44 = new Comb;
}

void test44()
{
    c44 = Foo44(Foo44(c44));
}

/*******************************************/

class Bar45
{
    void test()
    {
        a = 4;
        Inner i = new Inner;
        i.foo();
    }

    class Inner
    {
        void foo()
        {
            assert(a == 4);
            Inner i = new Inner;
            i.bar();
        }

        void bar()
        {
            assert(a == 4);
        }
    }
    int a;
}

void test45()
{
    Bar45 b = new Bar45;
    assert(b.a == 0);
    b.test();
}

/*******************************************/

class Adapter
{
    int a = 2;

    int func()
    {
        return 73;
    }
}

class Foo46
{
    int b = 7;

    class AnonAdapter : Adapter
    {
        int aa = 8;

        this()
        {
            assert(b == 7);
            assert(aa == 8);
        }
    }

    void func()
    {
        Adapter a = cast( Adapter )( new AnonAdapter() );
        assert(a.func() == 73);
        assert(a.a == 2);
    }
}

void test46()
{
    Foo46 f = new Foo46();
    f.func();
}


/*******************************************/

void test47()
{
    void delegate() test =
    {
        struct Foo {int x=3;}
        Foo f;
        assert(f.x == 3);
    };
    test();
}

/*******************************************/

struct Outer48
{
    class Inner
    {
        this(int i) { b = i; }
        int b;
    }

    int a = 6;

    void f()
    {
        int nested()
        {
            auto x = new Inner(a);
            return x.b + 1;
        }
        int i = nested();
        assert(i == 7);
    }
}


void test48()
{
    Outer48 s;
    s.f();
}

/*******************************************/

void test49()
{
    int j = 10;
    void mainlocal(int x)
    {
        printf("mainlocal: j = %d, x = %d\n", j, x);
        assert(j == 10);
        assert(x == 1);
    }

    void fun2()
    {
        int k = 20;
        void fun2local(int x)
        {
            printf("fun2local: k = %d, x = %d\n", k, x);
            assert(j == 10);
            assert(k == 20);
            assert(x == 2);
        }

        void fun1()
        {
            mainlocal(1);
            fun2local(2);
        }

        fun1();
    }

    fun2();
}

/*******************************************/

void funa50(alias pred1, alias pred2)()
{
    pred1(1);
    pred2(2);
}

void funb50(alias pred1)()
{   int k = 20;
    void funb50local(int x)
    {
        printf("funb50local: k = %d, x = %d\n", k, x);
        assert(k == 20);
        assert(x == 2);
    }
    funa50!(pred1, funb50local)();
}

void test50()
{
    int j = 10;
    void mainlocal(int x)
    {
        printf("mainlocal: j = %d, x = %d\n", j, x);
        assert(j == 10);
        assert(x == 1);
    }
    funb50!(mainlocal)();
}

/*******************************************/

void funa51(alias pred1, alias pred2)()
{
    pred1(2);
    pred2(1);
}

void funb51(alias pred1)()
{   int k = 20;
    void funb51local(int x)
    {
        printf("funb51local: k = %d, x = %d\n", k, x);
        assert(k == 20);
        assert(x == 2);
    }
    funa51!(funb51local, pred1)();
}

void test51()
{
    int j = 10;
    void mainlocal(int x)
    {
        printf("mainlocal: j = %d, x = %d\n", j, x);
        assert(j == 10);
        assert(x == 1);
    }
    funb51!(mainlocal)();
}

/*******************************************/

C52 c52;

class C52
{
    int index = 7;
    void test1(){
        printf( "this = %p, index = %d\n", this, index );
        assert(index == 7);
        assert(this == c52);
    }
    void test()
    {
        class N
        {
            void callI()
            {
                printf("test1\n");
                test1();
                printf("test2\n");
                if (index is -1)
                {   // Access to the outer-super-field triggers the bug
                    printf("test3\n");
                }
            }
        }
        auto i = new N();
        i.callI();
    }
}

void test52()
{
    auto c = new C52;
    printf("c = %p\n", c);
    c52 = c;
    c.test();
}

/*******************************************/

void foo53(int i)
{
    struct SS
    {
        int x,y;
        int bar() { return x + i + 1; }
    }
    SS s;
    s.x = 3;
    assert(s.bar() == 11);
}

void test53()
{
    foo53(7);
}

/*******************************************/

void test54()
{
    int x = 40;
    int fun(int i) { return x + i; }

    struct A
    {
        int bar(int i) { return fun(i); }
    }

    A makeA()
    {
        // A a; return a;
        return A();
    }

    A makeA2()
    {
         A a;   return a;
        //return A();
    }

    A a = makeA();
    assert(a.bar(2) == 42);

    A b = makeA2();
    assert(b.bar(3) == 43);

    auto c = new A;
    assert(c.bar(4) == 44);
}
/*******************************************/

void test55()
{
    int localvar = 7;

    int inner(int delegate(ref int) dg) {
        int k = localvar;
        return 0;
    }

    int a = localvar * localvar; // This modifies the EAX register

    foreach (entry; &inner)
    {
    }
}

/*******************************************/
// 4401

void test4401()
{
    auto foo() {
        return 3;
    }

    auto bar() nothrow pure {
        return 3;
    }

    auto baz() @property pure @safe {
        return 3;
    }

    auto zoo()() @property pure @safe nothrow {
        return 3;
    }
}

/*******************************************/

alias void delegate() dg_t;

void Y(dg_t delegate (dg_t) y)
{
    struct F { void delegate(F) f; };

  version (all)
  { // generates error
    (dg_t delegate(F) a){return a(F((F b){return y(a(b))();})); }
    ((F b){return (){return b.f(b);};});
  }
  else
  {
    auto abc(dg_t delegate(F) a)
    {
        return a(F((F b){return y(a(b))();}));
    }

    abc((F b){return (){return b.f(b);};});
  }
}


void test7428(){
    dg_t foo(dg_t self)
    {
        void bar() { self(); }
        return &bar;
    }

    Y(&foo);
}

/*******************************************/

struct S4841(alias pred)
{
    void unused_func();
}

void abc4841() {
   int w;
   S4841!(w) m;
}

void test4841() {
   abc4841();
}

/*******************************************/


void index7199()
{
    void find()
    {
        bool hay()
        {
            return true;
        }
    }

    find();
}

void test7199()
{
    index7199();
}

/*******************************************/
// 7965

void test7965()
{
    int x;
    static int* px;
    px = &x;

    printf("&x = %p in main()\n", &x);
    struct S1
    {
        char y;
        void boom() {
            printf("&x = %p in S1.boom()\n", &x);
            assert(&x == px);
            //x = 42; // makes the struct nested
        }
    }
    S1 s1;
    s1.boom();

    struct S2
    {
        this(int n) {
            printf("&x = %p in S2.this()\n", &x);
            assert(&x == px);
        }
        char y;
    }
    S2 s2 = S2(10);
}

struct S7965
{
    string str;
    uint unused1, unused2 = 0;
}

auto f7965(alias fun)()
{
    struct Result
    {
        S7965 s;
        this(S7965 _s) { s = _s; }  // required for the problem
        void g() { assert(fun(s.str) == "xa"); }
    }

    return Result(S7965("a"));
}

void test7965a()
{
    string s = "x";
    f7965!(a => s ~= a)().g();
    assert(s == "xa");
}

/*******************************************/
// 8188

mixin template Print8188(b...)
{
    int doprint()
    {
        return b[0] * b[1];
    }
}

class A8188
{
    int x, y;
    mixin Print8188!(x, y);
}

void test8188()
{
    auto a = new A8188;
    a.x = 2;
    a.y = 5;
    assert(a.doprint() == 10);
}

/*******************************************/
// 5082

struct S5082 { float x; }

struct Map5082a(alias fun)
{
    typeof({ return fun(int.init); }()) cache;
}

struct Map5082b(alias fun)
{
    typeof({ return fun(int.init); }()) cache;

    S5082 front(int i) { return fun(i); }
}

void test5082()
{
    auto temp = S5082(1);
    auto func = (int v){ return temp; };
    auto map1 = Map5082a!func();
    auto map2 = Map5082b!func();
    assert(map2.front(1) == temp);
}


/*******************************************/
// 8194

void test8194()
{
    int foo;
    static void bar()
    {
        typeof(foo) baz;
        static assert(is(typeof(baz) == int));
    }
}

/*******************************************/
// 8339

template map8339a(fun...)
{
    auto map8339a(Range)(Range r) {
        struct Result {
            this(double[] input) {}
        }
        return Result(r);
    }
}
template map8339b(fun...)
{
    auto map8339b(Range)(Range r) {
        struct Result {
            this(double[] input) { fun[0](input.length); }
        }
        return Result(r);
    }
}
template map8339c(fun...)
{
    auto map8339c(Range)(Range r) {
        static struct Result {
            this(double[] input) {}
        }
        return Result(r);
    }
}
template map8339d(fun...)
{
    auto map8339d(Range)(Range r) {
        static struct Result {
            this(double[] input) { fun[0](input.length); }
        }
        return Result(r);
    }
}
void copy8339(T)(T x)
{
    T xSaved;
}
void test8339a()
{
    double[] x;
    int n;

    // Result has context pointer, so cannot copy
    static assert (!is(typeof({ copy8339(map8339a!(a=>a)(x)); })));
    static assert (!is(typeof({ copy8339(map8339a!(a=>n)(x)); })));

    // same as
    static assert (!is(typeof({ copy8339(map8339b!(a=>a)(x)); })));
    static assert (!is(typeof({ copy8339(map8339b!(a=>n)(x)); })));

    // fun is never instantiated
    copy8339(map8339c!(a=>a)(x));
    copy8339(map8339c!(a=>n)(x));

    // static nested struct doesn't have contest pointer
    copy8339(map8339d!(a=>a)(x));
  //copy8339(map8339d!(a=>n)(x));   // too strict case

}

template filter8339(alias pred)
{
    auto filter8339(R)(R r) {
        struct Result {
            R range;
            this(R r) { range = r; }
            auto front() { return pred(0); }
        }
        return Result(r);
    }
}
void test8339b()
{
    static makefilter() { int n; return filter8339!(a=>n)([]); }

    auto r1 = makefilter();
    filter8339!(a=>a)(r1);
}

void test8339c()
{
    class C(X) { X x; }
    class C1 { C!C1 x; }
    alias C!C1 C2;

    struct Pair { C1 t; C2 u; void func(){} }
    Pair pair;
}

/*******************************************/
// 8923

void test8923a()
{
    int val;

    struct S  // is nested struct
    {
        void foo() { val = 1; }  // access to val through the hidden frame pointer
    }
    S    s1a;           s1a.foo();
    S    s1b = S();     s1b.foo();
    S[1] s2a;           s2a[0].foo();
    S[1] s2b = S();     s2b[0].foo();

    static struct U { S s; }
    U    u1a;           u1a.s.foo();
    U    u1b = U();     u1b.s.foo();
    U    u1c = U(s1a);  u1c.s.foo();
    U[1] u2a;           u2a[0].s.foo();
    U[1] u2b = U();     u2b[0].s.foo();
    U[1] u2c = U(s1a);  u2c[0].s.foo();
    static struct V { S[1] s; }
    V    v1a;           v1a.s[0].foo();
    V    v1b = V();     v1b.s[0].foo();
    V    v1c = V(s1a);  v1c.s[0].foo();
    V[1] v2a;           v2a[0].s[0].foo();
    V[1] v2b = V();     v2b[0].s[0].foo();
    V[1] v2c = V(s1a);  v2c[0].s[0].foo();

    static struct W { S s; this(S s){ this.s = s; } }
    W    w1a;           w1a.s.foo();
    W    w1b = W();     w1b.s.foo();
    W    w1c = W(s1a);  w1c.s.foo();
    W[1] w2a;           w2a[0].s.foo();
    W[1] w2b = W();     w2b[0].s.foo();
    W[1] w2c = W(s1a);  w2c[0].s.foo();
    static struct X { S[1] s; this(S s){ this.s[] = s; } }
    X    x1a;           x1a.s[0].foo();
    X    x1b = X();     x1b.s[0].foo();
    X    x1c = X(s1a);  x1c.s[0].foo();
    X[1] x2a;           x2a[0].s[0].foo();
    X[1] x2b = X();     x2b[0].s[0].foo();
    X[1] x2c = X(s1a);  x2c[0].s[0].foo();

    // Both declarations, Y and Z should raise errors,
    // because their ctors don't initialize their field 's'.
  static assert(!__traits(compiles, {
    static struct Y { S s; this(S){} }
  }));
/+  Y    y1a;         //y1a.s.foo();
    Y    y1b = Y();     y1b.s.foo();
    Y    y1c = Y(s1a);//y1c.s.foo();
    Y[1] y2a;         //y2a[0].s.foo();
    Y[1] y2b = Y();     y2b[0].s.foo();
    Y[1] y2c = Y(s1a);//y2c[0].s.foo();  +/
  static assert(!__traits(compiles, {
    static struct Z { S[1] s; this(S){} }
  }));
/+  Z    z1a;         //z1a.s[0].foo();
    Z    z1b = Z();     z1b.s[0].foo();
    Z    z1c = Z(s1a);//z1c.s[0].foo();
    Z[1] z2a;         //z1a.s[0].foo();
    Z[1] z2b = Z();     z1b.s[0].foo();
    Z[1] z2c = Z(s1a);//z1c.s[0].foo();  // +/
}

struct Tuple8923(int v, T...)
{
    T field;
    static if (v == 1) this(T args) { }    // should be an error
    static if (v == 2) this(T args) { field = args; }
    static if (v == 3) this(U...)(U args) { }    // should be an error
    static if (v == 4) this(U...)(U args) { field = args; }
    //alias field this;
}
void test8923b()
{
    int val;
    struct S { void foo() { val = 1; } }

  static assert(!__traits(compiles, Tuple8923!(1, S)(S()) ));
  static assert(!__traits(compiles, Tuple8923!(3, S)(S()) ));

    auto tup2 = Tuple8923!(2, S)(S());
    tup2.field[0].foo();    // correctly initialized

    auto tup4 = Tuple8923!(4, S)(S());
    tup4.field[0].foo();    // correctly initialized
}

void test8923c()
{
    int val;

    struct S  // is nested struct
    {
        void foo() { val = 1; }  // access to val through the hidden frame pointer
    }
    S    s1a;           s1a.foo();
    S    s1b = S();     s1b.foo();
    S[1] s2a;           s2a[0].foo();
    S[1] s2b = S();     s2b[0].foo();

    // U,V,W,X are nested struct, but should work same as non-nested.
    // 1: bare struct object.  2: static array of structs.
    // a: default construction.
    // b: construction by literal syntax which has no argument.
    // c: construction by literal syntax which has one or more arguments.

    struct U
    {
        S s;
        void foo() { val = 2; }
    }
    U    u1a;           u1a.foo();      u1a.s.foo();
    U    u1b = U();     u1b.foo();      u1b.s.foo();
    U    u1c = U(s1a);  u1c.foo();      u1c.s.foo();
    U[1] u2a;           u2a[0].foo();   u2a[0].s.foo();
    U[1] u2b = U();     u2b[0].foo();   u2b[0].s.foo();
    U[1] u2c = U(s1a);  u2c[0].foo();   u2c[0].s.foo();

    struct V
    {
        S[1] s;
        void foo() { val = 2; }
    }
    V    v1a;           v1a.foo();      v1a.s[0].foo();
    V    v1b = V();     v1b.foo();      v1b.s[0].foo();
    V    v1c = V(s1a);  v1c.foo();      v1c.s[0].foo();
    V[1] v2a;           v2a[0].foo();   v2a[0].s[0].foo();
    V[1] v2b = V();     v2b[0].foo();   v2b[0].s[0].foo();
    V[1] v2c = V(s1a);  v2c[0].foo();   v2c[0].s[0].foo();

    struct W
    {
        S s;
        this(S s) { this.s = s; }
        void foo() { val = 2; }
    }
    W    w1a;           w1a.foo();      w1a.s.foo();
    W    w1b = W();     w1b.foo();      w1b.s.foo();
    W    w1c = W(s1a);  w1c.foo();      w1c.s.foo();
    W[1] w2a;           w2a[0].foo();   w2a[0].s.foo();
    W[1] w2b = W();     w2b[0].foo();   w2b[0].s.foo();
    W[1] w2c = W(s1a);  w2c[0].foo();   w2c[0].s.foo();

    struct X
    {
        S[1] s;
        this(S s) { this.s[] = s; }
        void foo() { val = 2; }
    }
    X    x1a;           x1a.foo();      x1a.s[0].foo();
    X    x1b = X();     x1b.foo();      x1b.s[0].foo();
    X    x1c = X(s1a);  x1c.foo();      x1c.s[0].foo();
    X[1] x2a;           x2a[0].foo();   x2a[0].s[0].foo();
    X[1] x2b = X();     x2b[0].foo();   x2b[0].s[0].foo();
    X[1] x2c = X(s1a);  x2c[0].foo();   x2c[0].s[0].foo();

    // Both declarations, Y and Z should raise errors,
    // because their ctors don't initialize their field 's'.
  static assert(!__traits(compiles, {
    struct Y1 { S s; this(S){} void foo() { val = 2; } }
  }));
  static assert(!__traits(compiles, {
    struct Y2 { S s; this(T)(S){} void foo() { val = 2; } }
    auto y2 = Y2!S(S());    // instantiate ctor
  }));

  static assert(!__traits(compiles, {
    struct Z1 { S[1] s; this(S){} void foo() { val = 2; } }
  }));
  static assert(!__traits(compiles, {
    struct Z2 { S[1] s; this(T)(S){} void foo() { val = 2; } }
    auto z2 = Z2!S(S());    // instantiate ctor
  }));
}

/*******************************************/
// 9003

void test9003()
{
    int i;
    struct NS {
        int n1;    // Comment to pass all asserts
        int n2;    // Uncomment to fail assert on line 19
        int f() { return i; }
    }

    static struct SS1 {
        NS ns;
    }
    SS1 ss1;
    assert(ss1.ns != NS.init);

    static struct SS2 {
        NS ns1, ns2;
    }
    SS2 ss2;
    assert(ss2.ns1 != NS.init); // line 19
    assert(ss2.ns2 != NS.init);

    static struct SS3 {
        int i;
        NS ns;
    }

    SS3 ss3;
    assert(ss3.ns != NS.init);

    static struct SS4 {
        int i;
        NS ns1, ns2;
    }

    SS4 ss4;
    assert(ss4.ns1 != NS.init); // fails
    assert(ss4.ns2 != NS.init); // fails
}

/*******************************************/
// 9006

void test9006()
{
    int i;
    struct NS
    {
        int n;
        int[3] a; // Uncomment to fail assert on line 20 and pass on line 23
        int f() { return i; }
    }
    NS ns;
    assert(ns != NS.init);
    ns = NS.init;
    assert(ns == NS.init);

    static struct SS { NS ns; }
    assert(SS.init.ns == NS.init); // fails
    assert(SS.init.ns != NS());    // fails

    SS s;
    assert(s.ns != NS.init); // line 20
    assert(s != SS.init);    // fails
    s = SS.init;
    assert(s.ns == NS.init); // line 23, fails
    assert(s == SS.init);
}

/*******************************************/
// 9035

void test9035()
{
    static struct S {}

    void f(T)(auto ref T t)
    {
        static assert(!__traits(isRef, t));
    }

    f(S.init); // ok, rvalue
    f(S());    // ok, rvalue

    int i;
    struct Nested
    {
        int j = 0; void f() { ++i; }
    }

    f(Nested());    // ok, rvalue
    f(Nested.init); // fails, lvalue

    assert(Nested.init.j == 0);
    //(ref n) { n.j = 5; }(Nested.init);
    assert(Nested.init.j == 0); // fails, j is 5
}

void test9035a()
{
    int x;
    struct S {
        // no field
        void foo() { x = 1; }
    }
    S s1;
    S s2 = S();
    assert(s1  != S.init);  // OK
    assert(s2  != S.init);  // OK
    assert(S() != S.init);  // NG -> OK
}

/*******************************************/
// 9036

void test9036()
{
    static int i;
    static struct S
    {
        this(this) { ++i; }
    }

    S s = S.init;
    assert(i == 0); // postblit not called
    s = S.init;
    assert(i == 0); // postblit not called

    int k;
    static int j = 0;
    struct N
    {
        this(this)
        {
            ++j;
            assert(this.tupleof[$-1] != null); // fails
        }
        void f() { ++k; }
    }

    N n = N.init;
    assert(j == 0); // fails, j = 1, postblit called
    n = N.init;
    assert(j == 0); // fails, j = 2, postblit called
}

/*******************************************/
// 8847

auto S8847()
{
    static struct Result
    {
        inout(Result) get() inout { return this; }
    }
    return Result();
}

void test8847a()
{
    auto a = S8847();
    auto b = a.get();
    alias typeof(a) A;
    alias typeof(b) B;
    assert(is(A == B), A.stringof~ " is different from "~B.stringof);
}

// --------

enum result8847a = "S6nested9iota8847aFZ6Result";
enum result8847b = "S6nested9iota8847bFZ4iotaMFZ6Result";
enum result8847c = "C6nested9iota8847cFZ6Result";
enum result8847d = "C6nested9iota8847dFZ4iotaMFZ6Result";

auto iota8847a()
{
    static struct Result
    {
        this(int) {}
        inout(Result) test() inout { return cast(inout)Result(0); }
    }
    static assert(Result.mangleof == result8847a);
    return Result.init;
}
auto iota8847b()
{
    auto iota()
    {
        static struct Result
        {
            this(int) {}
            inout(Result) test() inout { return cast(inout)Result(0); }
        }
        static assert(Result.mangleof == result8847b);
        return Result.init;
    }
    return iota();
}
auto iota8847c()
{
    static class Result
    {
        this(int) {}
        inout(Result) test() inout { return cast(inout)new Result(0); }
    }
    static assert(Result.mangleof == result8847c);
    return Result.init;
}
auto iota8847d()
{
    auto iota()
    {
        static class Result
        {
            this(int) {}
            inout(Result) test() inout { return cast(inout)new Result(0); }
        }
        static assert(Result.mangleof == result8847d);
        return Result.init;
    }
    return iota();
}
void test8847b()
{
    static assert(typeof(iota8847a().test()).mangleof == result8847a);
    static assert(typeof(iota8847b().test()).mangleof == result8847b);
    static assert(typeof(iota8847c().test()).mangleof == result8847c);
    static assert(typeof(iota8847d().test()).mangleof == result8847d);
}

// --------

struct Test8847
{
    enum result1 = "S6nested8Test88478__T3fooZ3fooMFZ6Result";
    enum result2 = "S6nested8Test88478__T3fooZ3fooMxFiZ6Result";

    auto foo()()
    {
        static struct Result
        {
            inout(Result) get() inout { return this; }
        }
        static assert(Result.mangleof == Test8847.result1);
        return Result();
    }
    auto foo()(int n) const
    {
        static struct Result
        {
            inout(Result) get() inout { return this; }
        }
        static assert(Result.mangleof == Test8847.result2);
        return Result();
    }
}
void test8847c()
{
    static assert(typeof(Test8847().foo( ).get()).mangleof == Test8847.result1);
    static assert(typeof(Test8847().foo(1).get()).mangleof == Test8847.result2);
}

// --------

void test8847d()
{
    enum resultS = "S6nested9test8847dFZv3fooMFZ3barMFZAya3bazMFZ1S";
    enum resultX = "S6nested9test8847dFZv3fooMFZ1X";
    // Return types for test8847d and bar are mangled correctly,
    // and return types for foo and baz are not mangled correctly.

    auto foo()
    {
        struct X { inout(X) get() inout { return inout(X)(); } }
        string bar()
        {
            auto baz()
            {
                struct S { inout(S) get() inout { return inout(S)(); } }
                return S();
            }
            static assert(typeof(baz()      ).mangleof == resultS);
            static assert(typeof(baz().get()).mangleof == resultS);
            return "";
        }
        return X();
    }
    static assert(typeof(foo()      ).mangleof == resultX);
    static assert(typeof(foo().get()).mangleof == resultX);
}

// --------

void test8847e()
{
    enum resultHere = "6nested"~"9test8847eFZv"~"8__T3fooZ"~"3foo";
    enum resultBar =  "S"~resultHere~"MFNaNfNgiZ3Bar";
    enum resultFoo = "_D"~resultHere~"MFNaNbNfNgiZNg"~resultBar;   // added 'Nb'

    // Make template function to infer 'nothrow' attributes
    auto foo()(inout int) pure @safe
    {
        struct Bar {}
        static assert(Bar.mangleof == resultBar);
        return inout(Bar)();
    }

    auto bar = foo(0);
    static assert(typeof(bar).stringof == "Bar");
    static assert(typeof(bar).mangleof == resultBar);
    static assert(foo!().mangleof == resultFoo);
}

/*******************************************/

/+
auto fun8863(T)(T* ret) { *ret = T(); }

void test8863()
{
    int x = 1;
    struct A
    {
        auto f()
        {
            assert(x == 1);
        }
    }

    A a;
    a.f();
    fun8863!A(&a);
    a.f();
}
+/

/*******************************************/
// 8774

void popFront8774()
{
    int[20] abc;    // smash stack
}

struct MapResult8774(alias fun)
{
    void delegate() front()
    {
        return fun(1);
    }
}

void test8774() {

    int sliceSize = 100;

    void delegate() foo( int i )
    {
        void delegate() closedPartialSum()
        {
            int ii = i ;
            void bar()
            {
                printf("%d\n", sliceSize);
                assert(sliceSize == 100);
            }
            return &bar;
        }
        return closedPartialSum();
    }

    auto threads = MapResult8774!foo();

    auto dg = threads.front();
    popFront8774();

    printf("calling dg()\n");
    dg();
}

/*******************************************/

int Bug8832(alias X)()
{
    return X();
}

int delegate() foo8832()
{
  int stack;
  int heap = 3;

  int nested_func()
  {
    ++heap;
    return heap;
  }
  return delegate int() { return Bug8832!(nested_func); };
}

void test8832()
{
  auto z = foo8832();
  auto p = foo8832();
  assert(z() == 4);
  p();
  assert(z() == 5);
}

/*******************************************/
// 9315

auto test9315()
{
    struct S
    {
        int i;
        void bar() {}
    }
    pragma(msg, S.init.tupleof[$-1]);
}

/*******************************************/
// 9244

void test9244()
{
    union U {
        int i;
        @safe int x() { return i; }
    }
}

/*******************************************/

int main()
{
    test1();
    test2();
    test3();
    test4();
    test5();
    test6();
    test7();
    test8();
    test9();
    test10();
    test11();
    test12();
    test13();
    test14();
    test15();
    test16();
    test17();
    test18();
    test19();
    test20();
    test21();
    test22();
    test23();
    test24();
    test25();
    test26();
    test27();
    test28();
    test29();
    test30();
    test31();
    test32();
    test33();
    test34();
    test35();
    test36();
    test37();
    test38();
    test39();
    test40();
    test41();
    test42();
    test43();
    test44();
    test45();
    test46();
    test47();
    test48();
    test49();
    test50();
    test51();
    test52();
    test53();
    test54();
    test55();
    test4401();
    test7428();
    test4841();
    test7199();
    test7965();
    test7965a();
    test8188();

    test5082();
    test8194();
    test8339a();
    test8339b();
    test8339c();
    test8923a();
    test8923b();
    test8923c();
    test9003();
    test9006();
    test9035();
    test9035a();
    test9036();
//    test8863();
    test8774();
    test8832();
    test9315();
    test9244();

    printf("Success\n");
    return 0;
}

