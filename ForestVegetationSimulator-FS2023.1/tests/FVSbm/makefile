
all : bmt01 bmt02

bmt01 : 
	@echo Test bmt01, basic functionality 
	../../bin/FVSbm --keywordfile=bmt01.key
	grep -v "\-999" bmt01.sum      > bmt01.tmp
	grep -v "\-999" bmt01.sum.save > bmt01.tmp.save
	-diff -w bmt01.tmp bmt01.tmp.save
	rm bmt01.tmp bmt01.tmp.save
	@echo Test bmt01 ended


bmt02 : 
	@echo Test bmt02, stop/restart
	../../bin/FVSbm --keywordfile=bmt01.key --stoppoint=2,2040,bmt.stop
	../../bin/FVSbm --restart=bmt.stop
	grep -v "\-999" bmt01.sum      > bmt01.tmp
	grep -v "\-999" bmt01.sum.save > bmt01.tmp.save
	-diff -w bmt01.tmp bmt01.tmp.save
	rm bmt01.tmp bmt01.tmp.save
	@echo Test bmt02 ended

clean : 
	rm -rfv bmt.stop bmt01.out bmt01.sng bmt01.sum FVS_Data.db FVSOut.db
