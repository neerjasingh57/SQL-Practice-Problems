With Orders2016 as (

Select c.CustomerID,
c.CompanyName,
Sum(Quantity*UnitPrice) as TotalOrderAmount
From Customers c 
Join Orders o on c.CustomerId = o.CustomerID
Join OrderDetails d on o.OrderID = d.OrderID
Where Year(OrderDate) = 2016
Group By c.CustomerId, c.CompanyName),

CustomerGrouping as (

Select CustomerID, 
CompanyName, 
TotalOrderAmount,
Case when TotalOrderAmount Between 0 and 1000 Then 'Low'
when TotalOrderAmount Between 1000 and 5000 Then 'Medium'
when TotalOrderAmount Between 5000 and 10000 Then 'High'
when TotalOrderAmount >= 10000 Then 'Very High'
End as CustomerGroup
From Orders2016)

Select CustomerGroup, 
Count(*) as TotalInGroup, 
Count(*)/(Select Count(*) From CustomerGrouping) as PercentageInGroup
From CustomerGrouping
Group By CustomerGroup
Order By TotalinGroup desc;
 
With UnionTable as (
Select Country From Customers
Union 
Select Country From Suppliers)#,

#DistinctCustomers as (
#Select Distinct(Country) From Customers),

#DistinctSuppliers as (
#Select Distinct(Country) From Suppliers)

Select Distinct(s.Country) as SupplierCountry, c.Country as CustomerCountry 
From UnionTable u 
Left Join Customers c On u.Country = c.Country
Left Join Suppliers s On u.Country = s.Country
Order By u.Country;

With UnionTable as (
Select Country From Customers
Union
Select Country From Suppliers)

Select 
u.Country,
Count(Distinct(SupplierID)) as TotalSuppliers,
Count(Distinct(CustomerID)) as TotalCustomers
From UnionTable u 
Left Join Customers c On u.Country = c.Country
Left Join Suppliers s On u.Country = s.Country
Group By u.Country
Order By u.Country;

With ShippedCountry as (
Select ShipCountry, CustomerID, OrderID, OrderDate,
Row_Number() Over (Partition By ShipCountry Order By OrderDate Asc) row_num
From Orders)

Select ShipCountry, CustomerID, OrderID, Date(OrderDate)
From ShippedCountry
Where row_num = 1;


















