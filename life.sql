create or replace procedure updateLife
    --'in' signifies that the variable is input
	(steps	in	integer)
as

	--define and create the primary array
	type lifeType is varray(225) of integer;
	lifeTable lifeType := lifeType(
	0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0,
	0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0,
	1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0,
	0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0,
	0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,
	1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0,
	0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0,
	0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
	1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1,
	0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1,
	0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
	0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0,
	0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
	0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0,
	0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0);

	--secondary table to store changes
	lifeTable2 lifeType := lifeType(
	0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0,
	0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0,
	1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0,
	0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0,
	0, 0, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0,
	1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0,
	0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0,
	0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0,
	1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1,
	0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 1,
	0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0,
	0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0,
	0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
	0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0,
	0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0);


    --i integer := 1;
	adj integer := 0;
	rowint integer := 0;
	colint integer := 0;

	--cardinal directions
	north integer := 0;
	ne integer := 0;
	e integer := 0;
	se integer := 0;
	s integer := 0;
	sw integer := 0;
	w integer := 0;
	nw integer := 0;

	--flags for being on an edge
	top boolean := false;
	leftside boolean := false;
	rightside boolean := false;
	bottom boolean := false;


begin

for x in 1..steps loop
	--loop through each row
	for i in 1..225 loop
		--store which row and column we are in
		rowint := i / 15;
		colint := mod(i, 15);

		--set directions to 0 by default
		north := 	0;
		ne := 		0;
		e := 		0;
		se := 		0;
		s := 		0;
		sw :=		0;
		w := 		0;
		nw := 		0;
		adj := 		0;

		--check the row above if we are in the second or below
		if i > 15 then
			top := false;
		else
			top := true;
		end if;

		--if we arent the first col check to the left
		if colint > 1 then
			leftside := false;
		else
			leftside := true;
		end if;

		--if we arent in last col check to the right
		if colint < 15 then
			rightside := false;
		else
			rightside := true;
		end if;

		--check the row below if we are not in the last row
		if i < 210 then
			bottom := false;
		else
			bottom := true;
		end if;

		--top left
		if not top and not leftside then
			nw := 		lifeTable(i - 16);
			north := 	lifeTable(i - 15);
		end if;

		--top right
		if not top and not rightside then
			north := 	lifeTable(i - 15);
			ne := 		lifeTable(i - 14);
		end if;

		--bottom left
		if not bottom and not leftside then
			s := 		lifeTable(i + 15);
			sw :=		lifeTable(i + 14);
		end if;

		--bottom right
		if not bottom and not leftside then
			s := 		lifeTable(i + 15);
			se :=		lifeTable(i + 16);
		end if;

		--left
		if not leftside then
			w := 		lifeTable(i - 1);
		end if;

		--right
		if not bottom and not leftside then
			e := 		lifeTable(i + 1);
		end if;

		--add up all living adjacent tiles
		adj := north + ne + e + se + s + sw + w + nw;

		--conways game of life logic
		if adj < 2 then
			lifeTable2(i) := 0;
		end if;

		if adj > 3 then
			lifeTable2(i) := 0;
		end if;

		if adj = 3 then
			lifeTable2(i) := 1;
		end if;

		/*
		if adj = 2 and lifeTable(i) = 1 then
			lifeTable2(i) := 1;
		end if;

		if adj = 2 and lifeTable(i) = 0 then
			lifeTable2(i) := 0;
		end if;
		*/

	end loop;

	--save table
	lifeTable := lifeTable2;

	--print data
	for i in 1..225 loop

		--add each element to buffer
		dbms_output.put(lifeTable(i) || '  ');

		--print buffer every 15
		if mod(i, 15) = 0 then
			dbms_output.new_line;
		end if;

	end loop;

	
	dbms_output.put_line(' ');


end loop;

end updateLife;

--to run:
--begin
--    updateLife(5);
--end;
--/




