module Bio.Fasta.Fasta
  (Fasta(..)
  )
where

import Data.Text
import Data.ByteString

data Fasta = Fasta {
  fastaName :: Text,
  fastaDesc :: Text,
  fastaSeq  :: ByteString
  } deriving Show
