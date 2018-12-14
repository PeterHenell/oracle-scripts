<RULESET title="Rules By Steven" version="NeedToAdd">
<PROPERTIES>
<SUMMARY>
<RULESET_TYPE>User</RULESET_TYPE>
<AUTHOR>SF</AUTHOR>
<CREATED>38817.8709421991</CREATED>
<MODIFIED>38817.8709421991</MODIFIED>
<COMMENTS/>
<RULESET_TOTAL>5</RULESET_TOTAL>
</SUMMARY>
<SEVERITY>
<SEV n="0" ico="297" total="2"/>
<SEV n="1" ico="298" total="1"/>
<SEV n="2" ico="299" total="2"/>
</SEVERITY>
<CATEGORY>
<CAT n="44" total="1"/>
<CAT n="58" total="1"/>
<CAT n="64" total="2"/>
<CAT n="68" total="1"/>
</CATEGORY>
<TYPES>
<TYPE n="0" total="3"/>
<TYPE n="1" total="2"/>
</TYPES>
<SORT_ORDER>
<SORT>TYPES</SORT>
</SORT_ORDER>
<SQL_SCAN_OPTIONS xpert="1">
<Preferences>
<SkipComment>False</SkipComment>
<SkipDualTableSQL>False</SkipDualTableSQL>
<EliminateDuplicate>False</EliminateDuplicate>
<WholeWordMatch>False</WholeWordMatch>
<MaxWordSize>1024</MaxWordSize>
<SkipLineStart>0</SkipLineStart>
<ComplexSetting>
<TableAccessed IncludeDual="False" From="2" To="3"/>
<FullIndexScan Selected="True"/>
</ComplexSetting>
<ProblematicSetting>
<FullTableScan Selected="True" IncludeDual="False" SizeIn="Kbytes" Size="8"/>
<NestedLoop Selected="True" IncludeDual="False" SizeIn="Kbytes" Size="8"/>
<RetrieveTableSize SelectIn="DBASegments"/>
</ProblematicSetting>
</Preferences>
</SQL_SCAN_OPTIONS>
<CODEXPERT_PREFS>
<OPTION1>0</OPTION1>
</CODEXPERT_PREFS>
</PROPERTIES>
<RULES>
<RULE rid="4401"/>
<RULE rid="6401"/>
<RULE rid="5813"/>
<RULE rid="6404"/>
<RULE rid="6802"/>
</RULES>
</RULESET>
