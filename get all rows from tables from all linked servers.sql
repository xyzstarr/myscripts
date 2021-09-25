declare @linked_servers table
(
    col1 varchar(255),
    col2 varchar(255),
    [name] varchar(255),
    [type] varchar(255),
    col3 varchar(255)
)

declare @linked_server_name varchar(50);
declare @rows_processed integer = 0;
declare cur cursor local fast_forward
for 
select name from sys.servers
where name not like '%.33.%'
open cur;  
fetch next from cur into @linked_server_name;  

while @@fetch_status = 0  
		begin 
		begin try
		insert @linked_servers exec sp_tables_ex @linked_server_name
		end try
		begin catch
		end catch
		if not exists (select * from sysobjects where name='Linked_Servers' and xtype='U')
		begin
			select * into Linked_Servers from @linked_servers
		end
		else
		begin
			insert into Linked_Servers
			select * from @linked_servers
		end

    fetch next from cur into @linked_server_name; 
    set @rows_processed = @rows_processed + 1;
end;
close cur;  
deallocate cur;
select * from Linked_Servers
