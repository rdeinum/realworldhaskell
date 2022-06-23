## Exercise 4
Take the predicates and combinators from “Gluing Predicates Together” on page 224 and make them work with our new Info type.

### Answer

```haskell
type InfoP a = Info -> a

liftP2 :: (a -> b -> c) -> InfoP a -> InfoP b -> InfoP c
liftP2 f ip1 ip2 i3 = ip1 i3 `f` ip2 i3

andI :: InfoP Bool -> InfoP Bool -> InfoP Bool
andI = liftP2 (&&)

orI :: InfoP Bool -> InfoP Bool -> InfoP Bool
orI = liftP2 (||)
```