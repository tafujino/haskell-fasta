module Bio.Fasta
  (Fasta(..)
  )
where

import Data.ByteString
import Data.Text

data Fasta = Fasta {
  fastaName :: Text,
  fastaDesc :: Text,
  fastaSeq  :: ByteString
  } deriving Show
