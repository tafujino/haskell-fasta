module Bio.Fasta.Fasta
  (Fasta(..)
  )
where

type NASeq = String

data Fasta = Fasta {
  fastaName   :: String,
  fastaDesc   :: String,
  fastaSeq    :: NASeq
  } deriving Show
