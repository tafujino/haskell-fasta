module Bio.Fasta.Parse
  (fasta1Parser,
   fastaParser
  )
where

import Prelude hiding (takeWhile)
import Bio.BioSeq
import Bio.Fasta
import Control.Applicative
import Control.Monad
import Data.Attoparsec.Applicative
import Data.Attoparsec.ByteString.Char8
import qualified Data.ByteString.Char8 as B8
import qualified Data.Text as T
import Data.Text.Encoding

nameP :: Parser T.Text
nameP = decodeUtf8 <$> takeWhile1 (not <$> isSpace)

descP :: Parser T.Text
descP = T.stripEnd . decodeUtf8 <$> takeWhile (not <$> isEndOfLine')

seqP :: BioSeq a => Parser a
seqP = fromIupacByteString . B8.concat <$>
       many1 (liftA2 B8.cons (notChar '>') (takeWhile (not <$> isSpace)) <* skipSpace' <* endOfLine)

fasta1Parser :: BioSeq a => Parser (Fasta a)
fasta1Parser = Fasta <$>
               -- unstrict FASTA may contain spaces after '>'
               (char '>' *> skipSpace' *> nameP) <* skipSpace' <*>
               descP <* endOfLine <*>
               seqP

fastaParser :: BioSeq a => Parser [Fasta a]
fastaParser = many1 fasta1Parser <* skipSpace <* endOfInput
