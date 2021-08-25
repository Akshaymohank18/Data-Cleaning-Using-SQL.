select * 
from [portfolio project].[dbo].[nashville housing]

--standardise date--

alter table [nashville housing]
add saledateconverted date
update [nashville housing]
set saledateconverted =CONVERT(date,saleDate)

select * 
from [portfolio project].[dbo].[nashville housing]

--populating proprerty address data--

select * 
from [portfolio project].[dbo].[nashville housing]
where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolio project].[dbo].[nashville housing] a
join [portfolio project].[dbo].[nashville housing] b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from [portfolio project].[dbo].[nashville housing] a
join [portfolio project].[dbo].[nashville housing] b
 on a.ParcelID=b.ParcelID
 and a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 select * 
from [portfolio project].[dbo].[nashville housing]
where PropertyAddress is null

--breaking out address into individual columns--

select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',Propertyaddress)-1) as address
,SUBSTRING(PropertyAddress,CHARINDEX(',',Propertyaddress)+1,LEN(Propertyaddress)) as city
from [portfolio project].dbo.[nashville housing]

alter table [nashville housing]
add address Nvarchar(255)

update [nashville housing] 
set address =substring(PropertyAddress, 1,CHARINDEX(',',Propertyaddress)-1) 

alter table [nashville housing]
add city Nvarchar(255)

update [nashville housing]
set city =SUBSTRING(PropertyAddress,CHARINDEX(',',Propertyaddress)+1,LEN(Propertyaddress))

select *
from [portfolio project].dbo.[nashville housing]

select
PARSENAME(replace(OwnerAddress,',','.'),3) as street,
PARSENAME(replace(OwnerAddress,',','.'),2) as splitcity,
PARSENAME(replace(OwnerAddress,',','.'),1) as state
from [portfolio project].dbo.[nashville housing]

alter table [nashville housing]
add street Nvarchar(255),
    splitcity Nvarchar(255),
    state nvarchar(255)

update [nashville housing]
set street=PARSENAME(replace(OwnerAddress,',','.'),3),
    splitcity=PARSENAME(replace(OwnerAddress,',','.'),2),
    state=PARSENAME(replace(OwnerAddress,',','.'),1)

select *
from [portfolio project].dbo.[nashville housing]

--changing y and n  to yes and no--

select distinct(SoldAsVacant) ,count(soldAsVacant)
from [portfolio project].dbo.[nashville housing]
group by SoldAsVacant
order by 2

select 
case when SoldAsVacant='Y' then 'YES'
     when SoldAsVacant='N' then 'NO'
	 else SoldAsVacant
	 end
from [portfolio project].dbo.[nashville housing]

update [nashville housing]
set SoldAsVacant=case when SoldAsVacant='Y' then 'YES'
     when SoldAsVacant='N' then 'NO'
	 else SoldAsVacant
	 end

select distinct(SoldAsVacant)
from [portfolio project].dbo.[nashville housing]

--removing duplicates --

with RowNumCTE  as(
select *,
 ROW_NUMBER() over( partition by 
            ParcelID,
            PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by UniqueID) row_num
from [portfolio project].dbo.[nashville housing] )
delete 
from RowNumCTE
where row_num>1
--checking..


with RowNumCTE  as(
select *,
 ROW_NUMBER() over( partition by 
            ParcelID,
            PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by UniqueID) row_num
from [portfolio project].dbo.[nashville housing] )
select * 
from RowNumCTE
where row_num>1
order by PropertyAddress

--deleting unwanted raws--

select * 
from [portfolio project].[dbo].[nashville housing]

alter table [nashville housing]
drop column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate

select * 
from [portfolio project].[dbo].[nashville housing]
