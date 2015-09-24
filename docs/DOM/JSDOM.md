## Module DOM.JSDOM

#### `JSDOM`

``` purescript
data JSDOM :: !
```

#### `Callback`

``` purescript
type Callback eff a = Either Error a -> Eff (jsdom :: JSDOM | eff) Unit
```

#### `env`

``` purescript
env :: forall configs eff. String -> Array String -> {  | configs } -> Callback eff Window -> Eff (jsdom :: JSDOM | eff) Unit
```

#### `envAff`

``` purescript
envAff :: forall configs eff. String -> Array String -> {  | configs } -> Aff (jsdom :: JSDOM | eff) Window
```

#### `jsdom`

``` purescript
jsdom :: forall configs eff. String -> {  | configs } -> Eff (jsdom :: JSDOM | eff) Document
```


