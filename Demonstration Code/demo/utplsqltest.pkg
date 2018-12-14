create or replace package utplsqltest is
	procedure ut_setup;
	procedure ut_teardown;

	procedure ut_dummy1;
	procedure ut_dummy2;

	procedure ut_getTests;
	procedure ut_runTests;
	procedure ut_runTest;
	procedure ut_reportResults;

	procedure ut_assertThisFailure;
	procedure ut_assertThisSuccess;

	procedure ut_assertEqNumber;
	procedure ut_assertEqNumberNull1;
	procedure ut_assertEqNumberNull2;
	procedure ut_assertEqNumberBothNull;
	procedure ut_assertEqNumberBothNullOk;

	procedure ut_assertEqVarchar;
	procedure ut_assertEqVarcharNull1;
	procedure ut_assertEqVarcharNull2;
	procedure ut_assertEqVarcharBothNullOk;
	procedure ut_assertEqVarcharBothNull;

	procedure ut_assertEqDate;
	procedure ut_assertEqDateNull1;
	procedure ut_assertEqDateNull2;
	procedure ut_assertEqDateBothNullOk;
	procedure ut_assertEqDateBothNull;

	procedure ut_assertEqBoolean;
	procedure ut_assertEqBooleanNull1;
	procedure ut_assertEqBooleanNull2;
	procedure ut_assertEqBooleanBothNullOk;
	procedure ut_assertEqBooleanBothNull;
end;
/
show errors

create or replace package body utplsqltest is
	setupCalled boolean := false;
	teardownCalled boolean := false;
	dummy1Called boolean := false;
	dummy2Called boolean := false;

	thisPkg varchar2(30) := 'utplsqltest';



	procedure ut_reset is
	begin
		setupCalled := false;
		teardownCalled := false;
		dummy1Called := false;
		dummy2Called := false;
	end;

	procedure ut_setup is
	begin
		setupCalled := true;
	end;

	procedure ut_teardown is
	begin
		teardownCalled := true;
	end;

	procedure ut_dummy1 is
	begin
		dummy1Called := true;
	end;

	procedure ut_dummy2 is
	begin
		dummy2Called := true;
	end;


	---------------------------------------------------------------------------
	-- Test utplsql.
	---------------------------------------------------------------------------


	procedure ut_getTests is
		tests utplsql.TestCollection;
	begin
		tests := utplsql.getTests('xx');
		utassert.this('getTests for xx.', tests.count = 0);
		tests := utplsql.getTests(thisPkg);
		utassert.this('getTests count for ' || thisPkg, tests.count > 8);
		utassert.this('getTests setup for ' || thisPkg, tests(1).setupExists);
		utassert.this('getTests teardown for ' || thisPkg, tests(1).teardownExists);
	end;




	procedure ut_runTests is
		tests utplsql.TestCollection;
		results utplsql.ResultCollection;
	begin
		tests := utplsql.TestCollection();
		tests.extend;
		tests(1).pkg := thisPkg;
		tests(1).name := 'ut_dummy1';
		tests.extend;
		tests(2).pkg := thisPkg;
		tests(2).name := 'ut_dummy2';
		results := utplsql.runTests(tests);
		utassert.this('runTests: runTests results.count for ' || thisPkg, results.count = 2);
	end;




	procedure ut_runTest is
		test utplsql.TestRecord;
		results utplsql.ResultCollection;
	begin
		test.pkg := thisPkg;
		test.name := 'ut_dummy1';
		test.setupExists := true;
		test.teardownExists := true;
		ut_reset;
		results := utplsql.runTest(test);
		utassert.this('runTest: runTest count.', results.count = 1);
		utassert.this('runTest: runTest success.', results(1).success);
		utassert.this('runTest ut_setup.', setupCalled);
		utassert.this('runTest ut_teardown.', teardownCalled);
		utassert.this('runTest ut_dummy1.', dummy1Called);
	end;



	procedure ut_reportResults is
		results utplsql.ResultCollection;
		actual varchar2(2000);
		expected varchar2(2000);
		status number;
	begin
		results := utplsql.ResultCollection();
		results.extend;
		results(1).pkg := thisPkg;
		results(1).name := 'ut_dummy1';
		results(1).success := true;
		results.extend;
		results(2).pkg := thisPkg;
		results(2).name := 'ut_dummy2';
		results(2).success := false;
		results(2).msg := 'some assertion failure';
		dbms_output.enable(10000);
		utplsql.reportResults(results);

		expected := 'Success: ' || results(1).pkg || '.' || results(1).name;
		dbms_output.get_line(actual, status);
		utassert.this('reportResults line1', actual = expected);

		expected := 'FAILURE: ' || results(2).pkg || '.' || results(2).name || ' : ' || results(2).msg;
		dbms_output.get_line(actual, status);
		utassert.this('reportResults line2', actual = expected);

		dbms_output.enable(10000);
	end;



	---------------------------------------------------------------------------
	-- Test utassert.
	---------------------------------------------------------------------------



	procedure assertHelper(name varchar2, success boolean) is
		results utplsql.ResultCollection;
	begin
		utassert.testComplete;
		results := utassert.results;
		utassert.reset;
		utassert.eq('assert results.count', results.count, 1);
		utassert.eq('assert result.pkg', results(1).pkg, thisPkg);
		utassert.eq('assert result.name', results(1).name, name);
		utassert.eq('assert result.success', results(1).success, success);
	end;



	-- These tests reset the assert package.
	-- That's OK because it's reset at the start of each test anyway.
	-- Then the test creates a negative result (using utassert.this and/or utassert.testComplete)
	-- saves the results, resets the package (again),
	-- and then uses the package to assert that the saved results were as expected.
	-- The joys of self-testing...


	procedure ut_assertThisFailure is
	begin
		utassert.reset;
		utassert.this('test', false);
		assertHelper(utplsql.currentTest().name, false);
	end;



	procedure ut_assertThisSuccess is
	begin
		utassert.reset;
		utassert.this('test', true);
		assertHelper(utplsql.currentTest().name, true);
	end;


	-- Eq Number  ---------------------------------------------


	procedure ut_assertEqNumber is
		value number := 1;
	begin
		utassert.reset;
		utassert.eq('test', value, value);
		assertHelper(utplsql.currentTest().name, true);
	end;


	procedure ut_assertEqNumberNull1 is
		value number := 1;
	begin
		utassert.reset;
		utassert.eq('test', null, value);
		assertHelper(utplsql.currentTest().name, false);
	end;



	procedure ut_assertEqNumberNull2 is
		value number := 1;
	begin
		utassert.reset;
		utassert.eq('test', value, null);
		assertHelper(utplsql.currentTest().name, false);
	end;



	procedure ut_assertEqNumberBothNullOk is
		nullvalue number := to_number(null);
	begin
		utassert.reset;
		utassert.eq('test', nullvalue, nullvalue);
		assertHelper(utplsql.currentTest().name, true);
	end;



	procedure ut_assertEqNumberBothNull is
		nullvalue number := to_number(null);
	begin
		utassert.reset;
		utassert.eq('test', nullvalue, nullvalue, false);
		assertHelper(utplsql.currentTest().name, false);
	end;



	-- Eq Varchar  ---------------------------------------------


	procedure ut_assertEqVarchar is
		value varchar2(1) := 'x';
	begin
		utassert.reset;
		utassert.eq('test', value, value);
		assertHelper(utplsql.currentTest().name, true);
	end;


	procedure ut_assertEqVarcharNull1 is
		value varchar2(1) := 'x';
	begin
		utassert.reset;
		utassert.eq('test', null, value);
		assertHelper(utplsql.currentTest().name, false);
	end;



	procedure ut_assertEqVarcharNull2 is
		value varchar2(1) := 'x';
	begin
		utassert.reset;
		utassert.eq('test', value, null);
		assertHelper(utplsql.currentTest().name, false);
	end;



	procedure ut_assertEqVarcharBothNullOk is
		nullvalue varchar2(1) := to_char(null);
	begin
		utassert.reset;
		utassert.eq('test', nullvalue, nullvalue);
		assertHelper(utplsql.currentTest().name, true);
	end;



	procedure ut_assertEqVarcharBothNull is
		nullvalue varchar2(1) := to_char(null);
	begin
		utassert.reset;
		utassert.eq('test', nullvalue, nullvalue, false);
		assertHelper(utplsql.currentTest().name, false);
	end;




	-- Eq Date  ---------------------------------------------


	procedure ut_assertEqDate is
		value date := to_date('01-jan-2000', 'dd-mon-yyyy');
	begin
		utassert.reset;
		utassert.eq('test', value, value);
		assertHelper(utplsql.currentTest().name, true);
	end;


	procedure ut_assertEqDateNull1 is
		value date := to_date('01-jan-2000', 'dd-mon-yyyy');
	begin
		utassert.reset;
		utassert.eq('test', null, value);
		assertHelper(utplsql.currentTest().name, false);
	end;



	procedure ut_assertEqDateNull2 is
		value date := to_date('01-jan-2000', 'dd-mon-yyyy');
	begin
		utassert.reset;
		utassert.eq('test', value, null);
		assertHelper(utplsql.currentTest().name, false);
	end;



	procedure ut_assertEqDateBothNullOk is
		nullvalue date := to_date(null, 'dd-mon-yyyy');
	begin
		utassert.reset;
		utassert.eq('test', nullvalue, nullvalue);
		assertHelper(utplsql.currentTest().name, true);
	end;



	procedure ut_assertEqDateBothNull is
		nullvalue date := to_date(null, 'dd-mon-yyyy');
	begin
		utassert.reset;
		utassert.eq('test', nullvalue, nullvalue, false);
		assertHelper(utplsql.currentTest().name, false);
	end;




	-- Eq Bool  ---------------------------------------------


	procedure ut_assertEqBoolean is
		value boolean := true;
	begin
		utassert.reset;
		utassert.eq('test', value, value);
		assertHelper(utplsql.currentTest().name, true);
	end;


	procedure ut_assertEqBooleanNull1 is
		value boolean := true;
	begin
		utassert.reset;
		utassert.eq('test', null, value);
		assertHelper(utplsql.currentTest().name, false);
	end;



	procedure ut_assertEqBooleanNull2 is
		value boolean := true;
	begin
		utassert.reset;
		utassert.eq('test', value, null);
		assertHelper(utplsql.currentTest().name, false);
	end;



	procedure ut_assertEqBooleanBothNullOk is
		nullvalue boolean := null;
	begin
		utassert.reset;
		utassert.eq('test', nullvalue, nullvalue);
		assertHelper(utplsql.currentTest().name, true);
	end;



	procedure ut_assertEqBooleanBothNull is
		nullvalue boolean := null;
	begin
		utassert.reset;
		utassert.eq('test', nullvalue, nullvalue, false);
		assertHelper(utplsql.currentTest().name, false);
	end;


end;
/
show errors

