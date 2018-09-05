module Bio.Fasta
where

import Bio.BioSeq
import Data.Text

data Fasta a = Fasta {
  fastaName :: Text,
  fastaDesc :: Text,
  fastaSeq  :: a
  } deriving Show
