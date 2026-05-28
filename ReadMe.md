files which contains a part of mate situations in reversi game in RFEN format.

# License  
Creative commons zero  

# Contents  
```
root + /tools
        scripts for maintanance.
     + /zstd
        zstd-ed files which contains mateN situations and results.
     + /zstd_split
        zstd-ed splitted files which contains mateN situations and results.
     + /merged
       raw text files which contains mateN situations and results.
     + /split
       splitted raw text files which contains mateN situations and results.
```

# How to add new data  
0. Prepare the consolidated file if it does not exist.  
   `tools/concat_splitted.rb` is available.  
1. Append the new data to the file.  
   `tools/usu.rb` is available.  
2. Split the updated file to keep each part less than 100MB.  
   `tools/split_by_leading_char.rb` is available.  

---
