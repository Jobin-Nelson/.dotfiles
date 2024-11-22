from abc import ABC, abstractmethod
from functools import partial, reduce
from inspect import signature
from typing import TypeAlias, TypeVar, Callable, Generic, Any, overload

A = TypeVar('A')  # Success type
B = TypeVar('B')  # Error type
C = TypeVar('C')
D = TypeVar('D')
E = TypeVar('E')

URCallable: TypeAlias = Callable[[A], B | 'URCallable']


class Maybe(Generic[A]):
    def __init__(self, value: A) -> None:
        self.value = value

    @classmethod
    def pure(cls, value: A) -> 'Maybe[A]':
        return cls(value)

    def map(self: 'Maybe[A]', f: Callable[[A], C]) -> 'Maybe[A] | Maybe[C]':
        if self.is_empty():
            return self
        return Maybe(f(self.value))

    def flatmap(
        self: 'Maybe[A]', f: Callable[[A], 'Maybe[C]']
    ) -> 'Maybe[A] | Maybe[C]':
        if self.is_empty():
            return self
        return f(self.value)

    def is_empty(self) -> bool:
        return self.value is None

    def is_present(self) -> bool:
        return not self.is_empty()

    def apply(
        self: 'Maybe[URCallable[C, D]]', other: 'Maybe[C]'
    ) -> 'Maybe[URCallable[C, D]] | Maybe[C] | Maybe[D | URCallable]':
        if self.is_empty():
            return self
        return other.map(self.value)

    def get_or_else(self, value: C) -> A | C:
        return value if self.is_empty() else self.value

    def __eq__(self, value: object, /) -> bool:
        return isinstance(value, Maybe) and self.value == self.value


def Just(value: A) -> Maybe[A]:
    return Maybe(value)


Nothing: Maybe[Any] = Maybe(None)


class Either(ABC, Generic[B, A]):
    def is_left(self) -> bool:
        return not self.is_right()

    @classmethod
    @abstractmethod
    def pure(cls, value) -> 'Either[B, A]':
        raise NotImplementedError

    @property
    @abstractmethod
    def value(self) -> A | B:
        raise NotImplementedError

    @abstractmethod
    def is_right(self) -> bool:
        raise NotImplementedError()

    @abstractmethod
    def map(self, func: Callable[[A], C]) -> 'Either[B, A] | Either[B, C]':
        raise NotImplementedError()

    @abstractmethod
    def flatmap(
        self, func: Callable[[A], 'Either[B, C]']
    ) -> 'Either[B, A] | Either[B, C]':
        raise NotImplementedError()

    @abstractmethod
    def apply(
        self: 'Either[B, URCallable[A, C]]', other: 'Either[B, A]'
    ) -> 'Either[B, URCallable[A, C]] | Either[B, A] | Either[B, C]':
        raise NotImplementedError()


class Left(Either[B, A]):
    def __init__(self, value: B) -> None:
        self._error = value

    @classmethod
    def pure(cls, value: B) -> Either[B, A]:
        return cls(value)

    def is_right(self) -> bool:
        return False

    def map(self, func: Callable[[A], C]) -> Either[B, A]:
        return self  # No transformation on Left

    def flatmap(self, func: Callable[[A], Either[B, C]]) -> Either[B, A]:
        return self  # No transformation on Left

    def get_or_else(self, value: A) -> A:
        return value

    def apply(self: Either[B, URCallable[A, C]], other: Either) -> Either:
        return self

    @property
    def value(self) -> B:
        return self._error

    def __eq__(self, value: object, /) -> bool:
        return isinstance(value, Left) and self.value == self.value


class Right(Either[B, A]):
    def __init__(self, value: A) -> None:
        self._value = value

    @classmethod
    def pure(cls, value: A) -> Either[B, A]:
        return cls(value)

    def is_right(self) -> bool:
        return True

    def map(self, func: Callable[[A], C]) -> Either[B, C]:
        return Right(func(self._value))

    def flatmap(self, func: Callable[[A], Either[B, C]]) -> Either[B, C]:
        return func(self._value)

    def get_or_else(self, value: A) -> A:
        return self.value

    def apply(self: 'Right[B, URCallable[A, C]]', other: Either) -> Either:
        return other.map(self.value)

    @property
    def value(self) -> A:
        return self._value

    def __eq__(self, value: object, /) -> bool:
        return isinstance(value, Right) and self.value == self.value


def curry(fn: Callable):
    def inner(arg):
        if len(signature(fn).parameters) == 1:
            return fn(arg)
        return curry(partial(fn, arg))

    return inner


def compose2(f: Callable[[B], C], g: Callable[[A], B]) -> Callable[[A], C]:
    def inner(x: A) -> C:
        return f(g(x))

    return inner


def identity(value: A) -> A:
    return value


def compose(*fn):
    return reduce(compose2, fn, identity)


# Monad: TypeAlias = Maybe[A] | Either[B, A]
# RMaybe: TypeAlias = Maybe[A] | Maybe[C] | Maybe[URCallable]
# REither: TypeAlias = Either[B, A] | Either[B, D] | Either[B, URCallable]
#
# @overload
# def liftA2(fn: URCallable[A, B], a: Maybe[A], b: Maybe[B]) -> RMaybe[A, C]: ...
# @overload
# def liftA2(fn: URCallable[A, C], a: Either[B, A], b: Either[B, C]) -> REither[B, A, D]: ...
def liftA2(fn, a, b):
    return a.map(fn).apply(b)