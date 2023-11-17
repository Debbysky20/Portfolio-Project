
-- -create a join table--

SELECT *
FROM Pharmaceutical_Database.dbo.Data$_xlnm#_FilterDatabase AS PH
INNER JOIN Pharmaceutical_Database.dbo.Data$ AS DB
ON PH.Distributor = DB.Distributor


---Find the list of distributors in Germany
SELECT country, Distributor
FROM Pharmaceutical_Database.dbo.Data$
WHERE Country = 'Germany'
ORDER BY Distributor ASC;

--Find the Total Sales of each customer
SELECT [Customer Name], [Product Name], Price * Quantity AS Total_sales
FROM Pharmaceutical_Database.dbo.Data$
WHERE Country = 'Germany'
ORDER BY Total_sales DESC;

--find all the drungs name that are in stock 
SELECT [Product Name], [Product Class], COUNT(DISTINCT [Product Name]) AS count_distinct
FROM Pharmaceutical_Database.dbo.Data$
WHERE price < 200
GROUP BY [Product Name], [Product Class]
ORDER BY [Product Name] DESC;

--Find the Average price of Analgesics
SELECT ROUND(AVG(Price), 2) AS AVG_Price
FROM Pharmaceutical_Database.dbo.Data$
WHERE [Product Class] = 'Analgesics'


--Find the top 10 Customers by Sales
SELECT top 10 [Customer Name], ROUND(SUM(Sales), 4) AS Total_Sales
FROM Pharmaceutical_Database.dbo.Data$
GROUP BY [Customer Name]
ORDER BY Total_Sales DESC

--Find the Average Sales for each country
SELECT Country, ROUND(AVG(Sales), 3) AS Avg_Sales
FROM Pharmaceutical_Database.dbo.Data$
GROUP BY Country
ORDER BY Avg_Sales DESC;

--Find the Total Number by Sales for each Product Class
SELECT [Product Class], COUNT(*) AS Total_Sales
FROM Pharmaceutical_Database.dbo.Data$
GROUP BY [Product Class]
ORDER BY Total_Sales DESC;

---Find the sales rep who has generated the most sales for a particular channel.
SELECT [Name of Sales Rep], ROUND(SUM(Sales), 4) AS Total_Sales
FROM Pharmaceutical_Database.dbo.Data$
WHERE Channel = 'Hospital'
GROUP BY [Name of Sales Rep]
ORDER BY Total_Sales DESC;

--Identify the top 10 customers by total sales across all channels 
SELECT top 10 [Customer Name], [Channel], SUM(Sales) AS Total_Sales
FROM Pharmaceutical_Database.dbo.Data$
GROUP BY [Customer Name], [Channel]
ORDER BY Total_Sales;

--Identify the top 10 customers by total sales across all sub-channels
SELECT top 10 [Customer Name], [Sub-channel], SUM(Sales) AS Total_Sales
FROM Pharmaceutical_Database.dbo.Data$
GROUP BY [Customer Name], [Sub-Channel]
ORDER BY Total_Sales;

---Calculate the average sales per customer for each city, considering both year and month.
SELECT TOP 20 City, Year, Month,ROUND(AVG(Sales), 2) AS Sales_Per_Customer
FROM Pharmaceutical_Database.dbo.Data$
GROUP BY City, Year,Month
ORDER BY Sales_Per_Customer DESC;

--Determine the product class with the highest average sales across all countries and channels.
SELECT TOP 1[Product Class], ROUND(AVG(Sales), 2) AS Avg_Sales, Country, Channel
FROM Pharmaceutical_Database.dbo.Data$
GROUP BY [Product Class], Country,Channel
ORDER BY Avg_Sales DESC;

---Identify the sales rep with the highest total sales for each channel and sub-channel combination.
SELECT [Manager], Channel, [Sub-channel], ROUND(SUM(Sales), 2) AS Total_Sales_Per_Chanel_Sub_Channel
FROM Pharmaceutical_Database.dbo.Data$
GROUP BY Manager,Channel,[Sub-channel]
ORDER BY Total_Sales_Per_Chanel_Sub_Channel, Channel, [Sub-channel] DESC;


---Analyze the sales trend for each product name, considering year and month.
SELECT TOP 20 [Product Name], Year, Month, ROUND(SUM(Sales), 2) AS Total_Sales_trend
FROM Pharmaceutical_Database.dbo.Data$
GROUP BY [Product Name], Year, Month
ORDER BY Total_Sales_trend DESC;








