module DOM.JSDOM
  ( JSDOM()
  , Callback()
  , env
  , envAff
  , jsdom
  ) where

import Control.Monad.Aff
import Control.Monad.Eff
import Control.Monad.Eff.Exception
import Data.Either
import Data.Function.Eff
import Data.Maybe
import Data.Nullable
import DOM.Node.Types
import DOM.HTML.Types
import Prelude

foreign import data JSDOM :: !

type JSCallback eff a = ExportEffFn2 (Nullable Error) a (Eff (jsdom :: JSDOM | eff) Unit)
type Callback eff a = Either Error a -> Eff (jsdom :: JSDOM | eff) Unit

toJSCallback :: forall a eff. Callback eff a -> JSCallback eff a
toJSCallback f = mkExportEffFn2 (\e a -> f $ maybe (Right a) Left (toMaybe e))

foreign import _jsdom ::
  { env :: forall configs eff. ImportEffFn4 String (Array String) { | configs} (JSCallback eff Window) (Eff (jsdom :: JSDOM | eff) Unit)
  , jsdom :: forall configs eff. ImportEffFn2 String { | configs} (Eff (jsdom :: JSDOM | eff) Document)
  }

env :: forall configs eff. String -> Array String -> { | configs} -> Callback eff Window -> (Eff (jsdom :: JSDOM | eff) Unit)
env urlOrHtml scripts configs callback = runImportEffFn4 _jsdom.env urlOrHtml scripts configs (toJSCallback callback)

envAff :: forall configs eff. String -> Array String -> { | configs} -> Aff (jsdom :: JSDOM | eff) Window
envAff urlOrHtml scripts configs = makeAff \e a -> env urlOrHtml scripts configs $ either e a

jsdom :: forall configs eff. String -> { | configs} -> Eff (jsdom :: JSDOM | eff) Document
jsdom markup configs = runImportEffFn2 _jsdom.jsdom markup configs
