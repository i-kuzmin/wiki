BEGIN {
    print "\n||  Когда  |  сколько  |  зачем  |";
}
{
    if (NR > 1) {
      total += $2;
      print "| " $1 " | " $2 " | " $3 " |";
    }
}
END {
  print "|   Итого: | " total "   | |";
}
