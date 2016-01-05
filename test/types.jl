# Hello world example, similar to the Boost.Python hello world

using CppWrapper
using Base.Test

# Wrap the functions defined in C++
wrap_modules(joinpath(Pkg.dir("CppWrapper"),"deps","usr","lib","libtypes"))

using CppTypes
using CppTypes.World

# Default constructor
@test World <: CppWrapper.CppAny
@test super(World) == CppWrapper.CppAny
w = World()
@test CppTypes.greet(w) == "default hello"

CppTypes.set(w, "hello")
@show CppTypes.greet(w)
@test CppTypes.greet(w) == "hello"

w = World("constructed")
@test CppTypes.greet(w) == "constructed"

w_assigned = w
w_deep = deepcopy(w)

@test w_assigned == w
@test w_deep != w

finalize(w)

@test_throws ErrorException CppTypes.greet(w)
@test_throws ErrorException CppTypes.greet(w_assigned)
@test CppTypes.greet(w_deep) == "constructed"

noncopyable = CppTypes.NonCopyable()
@test_throws ErrorException other_noncopyable = deepcopy(noncopyable)