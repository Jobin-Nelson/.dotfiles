from abc import ABC, abstractmethod
from functools import partial
from inspect import signature
from typing import TypeVar, Callable, Generic, Any

T = TypeVar('T')  # Success type
E = TypeVar('E')  # Error type
U = TypeVar('U')  # Return success type


class Maybe(Generic[T]):
    def __init__(self, value: T) -> None:
        self.value = value

    def map(self, f: Callable[[T], U]) -> 'Maybe[T] | Maybe[U]':
        if self.is_empty():
            return self
        return Maybe(f(self.value))

    def flat_map(self, f: Callable[[T], 'Maybe[U]']) -> 'Maybe[T] | Maybe[U]':
        if self.is_empty():
            return self
        return f(self.value)

    def is_empty(self) -> bool:
        return self.value is None

    def apply(self, other: 'Maybe[U]') -> 'Maybe[T]|Maybe[U]':
        if self.is_empty():
            return self
        if other.is_empty():
            return other
        return other.map(self.value)


def Just(value: T) -> Maybe[T]:
    return Maybe(value)


Nothing: Maybe[Any] = Maybe(None)


class Either(ABC, Generic[E, T]):
    def is_left(self) -> bool:
        return not self.is_right()

    @property
    @abstractmethod
    def value(self) -> T | E:
        raise NotImplementedError

    @abstractmethod
    def is_right(self) -> bool:
        raise NotImplementedError()

    @abstractmethod
    def map(self, func: Callable[[T], U]) -> 'Either[E, T] | Either[E, U]':
        raise NotImplementedError()

    @abstractmethod
    def flat_map(
        self, func: Callable[[T], 'Either[E, U]']
    ) -> 'Either[E, T] | Either[E, U]':
        raise NotImplementedError()

    @abstractmethod
    def apply(self, other: 'Either[E, U]') -> 'Either[E, T]| Either[E, U]':
        raise NotImplementedError()


class Left(Either[E, T]):
    def __init__(self, value: E) -> None:
        self._error = value

    def is_right(self) -> bool:
        return False

    def map(self, func: Callable[[T], U]) -> Either[E, T]:
        return self  # No transformation on Left

    def flat_map(self, func: Callable[[T], Either[E, U]]) -> Either[E, T]:
        return self  # No transformation on Left

    def apply(self, other: Either[E, U]) -> Either[E, T]:
        return self

    @property
    def value(self) -> E:
        return self._error


class Right(Either[E, T]):
    def __init__(self, value: T) -> None:
        self._value = value

    def is_right(self) -> bool:
        return True

    def map(self, func: Callable[[T], U]) -> Either[E, U]:
        return Right(func(self._value))

    def flat_map(self, func: Callable[[T], Either[E, U]]) -> Either[E, U]:
        return func(self._value)

    def apply(self, other: Either[E, U]) -> Either[E, T] | Either[E, U]:
        if other.is_left():
            return other
        return other.map(self.value)

    @property
    def value(self) -> T:
        return self._value


def curry(fn: Callable):
    def inner(arg):
        if len(signature(fn).parameters) == 1:
            return fn(arg)
        return curry(partial(fn, arg))

    return inner

# TODO add liftA2
# TODO add compose

