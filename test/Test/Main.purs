module Test.Main where

import Control.Bind
import Control.Monad.Aff
import Control.Monad.Eff
import Control.Monad.Eff.Class
import Control.Monad.Eff.Console(log)
import Control.Monad.Eff.Exception(error, throwException)
import Data.Maybe
import Data.Nullable
import Data.String(stripPrefix)
import Data.Traversable
import DOM.Node.Document
import DOM.Node.Node
import DOM.Node.Types
import DOM.HTML.Window
import DOM.HTML.Document
import DOM.HTML.Types
import Test.Assert
import Prelude
        
import DOM.JSDOM

firstText :: forall eff. Node -> Eff (dom :: DOM.DOM | eff) (Maybe String)
firstText node = join $ firstChild node <#> toMaybe >>> (map textContent) >>> sequence

exampleHTML = "<p>hogeika</p>"
exampleURI = "http://www.nicovideo.jp/"

main = do
  log "Testing jsdom"
  text <- (jsdom exampleHTML {}) <#> documentToNode >>= firstText
  assert $ text == Just "hogeika"

  log "Testing jsdom config"
  uri <- (jsdom exampleHTML { url: exampleURI }) >>= documentURI
  assert $ uri == exampleURI

  log "Testing envAff"
  runAff (\_ -> throwException $ error "envAff doesn't work") (const $ return unit) do
    window <- envAff exampleURI [] {}
    liftEff $ do
      uri <- document window <#> htmlDocumentToDocument >>= documentURI
      assert $ isJust $ stripPrefix exampleURI uri
