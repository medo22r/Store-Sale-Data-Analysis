-- ÃœÊ·  ﬁ—Ì— ‘«„· 
CREATE VIEW v_SalesReport AS
SELECT 
    F.Order_ID,
    F.Order_Date,
    F.Sales,
    C.Customer_Name, 
    C.Segment,
    P.Product_Name,
    P.Category,
    D.City,
    D.State
FROM 
    Fact_Table F
JOIN Customer_Detail C ON F.Customer_ID = C.Customer_ID
JOIN Product_Dim P ON F.Product_ID = P.Product_ID
JOIN Country_Details D ON F.Postal_Code = D.Postal_Code;
---------------------------------------
SELECT * FROM v_SalesReport
------------------------------------------------------------
SELECT 
    C.Customer_ID,
    C.Customer_Name,
    C.Segment,
    CAST(SUM(F.Sales) AS DECIMAL(12, 2)) AS Total_Sales
FROM Fact_Table F
JOIN Customer_Detail C ON F.Customer_ID = C.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name, C.Segment
ORDER BY Total_Sales DESC;
---------------------------------------------------
-- «·«ﬂÀ— ‘—«¡
SELECT 
    C.Customer_ID,
    C.Customer_Name,
    COUNT(DISTINCT F.Order_ID) AS Total_Orders,
    CAST(SUM(F.Sales) AS DECIMAL(12,2)) AS Total_Sales
FROM Fact_Table F
JOIN Customer_Detail C ON F.Customer_ID = C.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name
ORDER BY Total_Sales DESC;
----------------------------------------------------
-- «·«ﬂÀ— ÿ·»« 
SELECT 
    C.Customer_ID,
    C.Customer_Name,
    COUNT(DISTINCT F.Order_ID) AS Total_Orders,
    CAST(SUM(F.Sales) AS DECIMAL(12,2)) AS Total_Sales
FROM Fact_Table F
JOIN Customer_Detail C ON F.Customer_ID = C.Customer_ID
GROUP BY C.Customer_ID, C.Customer_Name
ORDER BY Total_Orders DESC;

-------------------------------------------------
-- «·„»Ì⁄«  Õ”» «· category
SELECT 
    P.Category,
    CAST(SUM(F.Sales) AS DECIMAL(12,2)) AS Total_Sales
FROM Fact_Table F
JOIN Product_Dim P ON F.Product_ID = P.Product_ID
GROUP BY P.Category
ORDER BY Total_Sales DESC;
-----------------------------------------------------
-- «·„»Ì⁄«  Õ”» «·„œÌ‰… 
SELECT 
    D.Country,
    D.City,
    CAST(SUM(F.Sales) AS DECIMAL(12,2)) AS Total_Sales
FROM Fact_Table F
JOIN Country_Details D ON F.Postal_Code = D.Postal_Code
GROUP BY D.Country, D.City
ORDER BY Total_Sales DESC;
----------------------------------------------
-- ⁄œœ «·ÿ·»«  Õ”» «·‘Â—
SELECT 
    FORMAT(F.Order_Date, 'yyyy-MM') AS Order_Month,
    COUNT(DISTINCT F.Order_ID) AS Total_Orders,
    CAST(SUM(F.Sales) AS DECIMAL(12,2)) AS Total_Sales
FROM Fact_Table F
GROUP BY FORMAT(F.Order_Date, 'yyyy-MM')
ORDER BY Order_Month;
--------------------------------------------------
SELECT 
    YEAR(F.Order_Date) AS Order_Year,
    MONTH(F.Order_Date) AS Order_Month,
    COUNT(DISTINCT F.Order_ID) AS Total_Orders,
    CAST(SUM(F.Sales) AS DECIMAL(12,2)) AS Total_Sales
FROM Fact_Table F
GROUP BY YEAR(F.Order_Date), MONTH(F.Order_Date)
ORDER BY Order_Year, Order_Month;
--------------------------------------------------
--totale sales per month and number of orde
SELECT 
    YEAR(F.Order_Date) AS Order_Year,
    DATENAME(MONTH, F.Order_Date) AS Order_Month,
    COUNT(DISTINCT F.Order_ID) AS Total_Orders,
    CAST(SUM(F.Sales) AS DECIMAL(12,2)) AS Total_Sales
FROM Fact_Table F
GROUP BY YEAR(F.Order_Date), DATENAME(MONTH, F.Order_Date), MONTH(F.Order_Date)
ORDER BY Order_Year, MONTH(F.Order_Date);
------------------------------------------------------------------
--5Tope Sale ›Ì ﬂ· 

WITH RankedProducts AS (
    SELECT 
        P.Category,
        P.Product_Name,
        CAST(SUM(F.Sales) AS DECIMAL(12,2)) AS Total_Sales,
        RANK() OVER (PARTITION BY P.Category ORDER BY SUM(F.Sales) DESC) AS RankInCategory
    FROM Fact_Table F
    JOIN Product_Dim P ON F.Product_ID = P.Product_ID
    GROUP BY P.Category, P.Product_Name
)
SELECT *
FROM RankedProducts
WHERE RankInCategory <= 5
ORDER BY Category, RankInCategory;
----------------------------------------------------------------------------
-- „⁄œ· «·ÿ·» Ê«·
SELECT 
    C.Segment,
    COUNT(DISTINCT F.Order_ID) AS Total_Orders,
    CAST(SUM(F.Sales) AS DECIMAL(12,2)) AS Total_Sales,
    CAST(AVG(F.Sales) AS DECIMAL(12,2)) AS Avg_Sale_Per_Order
FROM Fact_Table F
JOIN Customer_Detail C ON F.Customer_ID = C.Customer_ID
GROUP BY C.Segment
ORDER BY Total_Sales DESC;