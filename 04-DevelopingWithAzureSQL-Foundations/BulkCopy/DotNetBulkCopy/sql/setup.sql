drop table if exists dbo.BulkLoadedUsers;
create table dbo.BulkLoadedUsers
(
	Id int not null primary key,
	FirstName nvarchar(100) not null,
	LastName nvarchar(100) not null,
	UserName nvarchar(100) not null,
	Email nvarchar(1024) not null
)
go