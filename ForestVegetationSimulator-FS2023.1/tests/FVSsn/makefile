
all : snt01 snt02 sndb

snt01 : 
	@echo Test snt01, basic functionality 
	../../bin/FVSsn --keywordfile=snt01.key 
	grep -v "\-999" snt01.sum      > snt01.tmp
	grep -v "\-999" snt01.sum.save > snt01.tmp.save
	-diff -w snt01.tmp snt01.tmp.save
	rm snt01.tmp snt01.tmp.save
	@echo Test snt01 ended
	
snt02 : 
	@echo Test snt02, stop/restart, output should match snt01
	../../bin/FVSsn --keywordfile=snt01.key --stoppoint=2,2020,snt.stop
	../../bin/FVSsn --restart=snt.stop
	grep -v "\-999" snt01.sum      > snt01.tmp
	grep -v "\-999" snt01.sum.save > snt01.tmp.save
	-diff -w snt01.tmp snt01.tmp.save
	rm snt01.tmp snt01.tmp.save
	@echo Test snt02 ended
		 
sndb : 
	@echo sn variant database read and write, tests a lot of tables
	rm -f snout.db
	../../bin/FVSsn --keywordfile=sn.key  
	-sqlite3 snout.db < snTablesTest.sql > snout.txt
	-diff -w snout.txt snout.txt.save

clean : 
	rm -rfv sn.out sn.sng snout.db snout.db.sum snout.txt
	rm -rfv snt.stop snt01.out snt01.sng snt01.sum snt01.trl FVS_Data.db FVSOut.db