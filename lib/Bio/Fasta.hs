module Bio.Fasta
where

import Bio.BioSeq
import qualified Data.ByteString.Char8 as B8
import qualified Data.Text as T
import Data.Text.Encoding

data Fasta a = Fasta {
  fastaName :: T.Text,
  fastaDesc :: T.Text,
  fastaSeq  :: a
  } deriving Show

toByteString :: BioSeq a => Fasta a -> B8.ByteString
toByteString fa = B8.unlines [encodeUtf8 $ '>' `T.cons` fastaName fa `T.snoc` ' ' `T.append` fastaDesc fa,
                              toIupacByteString $ fastaSeq fa
                             ]
