
all : ttt01 ttt02

ttt01 : 
	@echo Test ttt01, basic functionality 
	../../bin/FVStt --keywordfile=ttt01.key
	grep -v "\-999" ttt01.sum      > ttt01.tmp
	grep -v "\-999" ttt01.sum.save > ttt01.tmp.save
	-diff -w ttt01.tmp ttt01.tmp.save
	rm ttt01.tmp ttt01.tmp.save
	@echo Test ttt01 ended

ttt02 : 
	@echo Test ttt02, stop/restart, output should match ttt01
	../../bin/FVStt --keywordfile=ttt01.key --stoppoint=2,2040,ttt.stop
	../../bin/FVStt --restart=ttt.stop
	grep -v "\-999" ttt01.sum      > ttt01.tmp
	grep -v "\-999" ttt01.sum.save > ttt01.tmp.save
	-diff -w ttt01.tmp ttt01.tmp.save
	rm ttt01.tmp ttt01.tmp.save
	@echo Test ttt02 ended

clean:
	rm -rfv ttt.stop ttt01.out ttt01.sng ttt01.sum FVS_Data.db FVSOut.db