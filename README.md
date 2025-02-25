# TechNova Trend and Strategy Analysis
Founded in 2018, TechNova is a global e-commerce company specializing in electronics and tech products. Initially focused on online sales, Technova has expanded its reach through both its website and mobile app, catering to a diverse international customer base.

To acquire and retain customers, Technova leverages a mix of marketing channels, including email campaigns, social media, SEO, and affiliate partnerships. The company has built a strong reputation for offering premium and high-demand tech products, particularly from Apple, Samsung, and ThinkPad, among others.

## Executive Summary
[TechNova’s sales peak in Nov-Dec but decline post-holidays. APAC shows premium potential with the highest AOV, while logistics inefficiencies in APAC & EMEA need optimization. High-value products and social media-driven sales drive the most refunds, despite social meida has the highest conversion rate, implying potential impulsive purchasing. The loyalty program fails to drive retention, with 99.53% of members making only one purchase. As returning customers generate higher average order value, there is a need to change loyalty program policy to increase returning customers. In addition, marketing should focus on social media (higher conversion rate) and affiliate program, which generates highest average order value. ]

## Deep Dive Insights
### Overview
The dataset covers a total orders count of 108K and total sales of $28M USD from 2019 to 2022. TechNova's customers are from 193 countries and there are 8 electronic products sold on the platform, including laptops, monitors, headphones, etc. 

### Trend Analysis
A sharp spike in March 2020 suggests a pandemic-driven surge in demand (e.g., for monitors, headphones, laptops, etc.), while a significant dip in October 2022 may indicate market shifts or economic factors. 

![Monthly total sales trend per product](https://github.com/user-attachments/assets/b477edb6-e7bc-49f0-a235-7fb305b31d67)

Seasonal patterns emerge with November and December consistently showing the highest growth, likely due to holiday shopping, followed by a drop in growth in the surrounding months. 

When comparing total sales growth, order count growth, and AOV growth, sales and order count growth are generally correlated, while AOV growth sometimes moves in the opposite direction, implying shifts toward higher-value purchases during certain periods.

Additionally, 2019 and 2020 show more positive growth spikes, whereas 2021 and 2022 exhibit more frequent declines, potentially due to post-pandemic saturation, inflation, or the nature of electronics being a less frequent purchase compared to essentials.

![Monthly Growth Rate 2019-2022](https://github.com/user-attachments/assets/b269e10b-dec3-460d-a5bb-73721f0f4ca6)


### Geographic Distribution
TechNova’s total sales are primarily concentrated in English-speaking countries, with the U.S. leading, followed by Great Britain (GB) and Canada (CA). The distribution pattern of total sales does not change across 2019 to 2022 but during the year of pandemic (2020), the amount of total sales increased across all the top 10 countries, indicating the global impact of high-demand in electronic devices caused by the pandemic. 

![Sheet 3](https://github.com/user-attachments/assets/845291a5-d4ff-4559-bd1d-051c280ab859)

At a regional level:
- North America (NA) has the highest total orders, followed by EMEA, APAC, and LATAM.
- EMEA has the highest average order value (AOV), surpassing APAC, North America and LATAM.

While the majority of the customers come from North America, TechNova should consider expanding more to EMEA market to convert the high-value customers. 
  
![Sheet 2-3](https://github.com/user-attachments/assets/6558c683-6bdb-4c20-8e4a-5558a2f79eed)


### Logistics 
Orders take an average of 7.51 days from purchase to delivery, with order processing taking 2.01 days and shipping taking 5.5 days. Regionally, there is not much difference, especially the avergae day of shipmnet to delivery is almost the same across the region. It's worth to note that in 2019, for APAC and EMEA, the average day from order to shipment is slightly longer comparing to LATAM and North America. However, starting from 2020, the logistic efficiency seemed to be normalized across all the 4 regions. 

![Logistic Efficiency per Region from 2019 to 2022  ](https://github.com/user-attachments/assets/6b1a31c8-2b25-4179-bb91-6e327fe05eea)


### Refund Rate 
Across 2019 to 2021, the laptops have higher refund rate, which might due to the nature and the price of the product. The refund rate decreased significantly in 2021 compared to 2019 and 2020; later in 2022, there is no data regarding refunds. 

Two explanations are possible. 
1. The information and the logistics improved significantly so that customers no longer regret their purchases at all.
2. The refund data is missing for 2022. 

Note that there is no refund for Bose Headphones across the 4 years. It's worth to understand what factors contribute to such a good result. 

![Refund Count per Product from 2019 to 2022](https://github.com/user-attachments/assets/ae5c142e-2b13-49c5-b6e0-51ea5fdc9dcc)

![Refund Rate per Product from 2019 to 2022 ](https://github.com/user-attachments/assets/c6271eeb-05d3-42db-90bd-0072717bd8ad)


### Loyalty Program
Among the 32,501 loyalty members, the customer lifetime value (CLV), which evaluates how valuable a customer is over time , is significantly lower than non-members, averaging only $242.75, compared to $313.37 for non-members. This indicates that loyalty members do not contribute as much long-term value as expected.

Additionally, loyalty members have fewer total orders (32,789) and average order value ($240.62) compared to non-members (48,071; $274.66). Members also exhibit a refund rate of 6.39%, which is higher than non-members (4.16%).  Across 2019 to 2021 (2022 didn't have any refund), all the members had higher refund rate, especially in 2020, members had 13% refund while non-members only had 7%, indicating that a positive correlation between loyalty program and refund rate. For the refunded items, loyalty members have a average refund price of $297.38, a total of 2,095 refunds and with the highest refund price of $1,444.94, while the corresponding numbers for non-members are $549.79 average refund price, 2,000 refunds, and the highest refund price of $3,146.88. The concerns for refunds and buying high-price items don't seem to be the reason that incentivize customers to join loyalty program. 

The most concerning trend is that 99.53% of loyalty members make only a single purchase while the repeat purchase rate for non-members is 23x higher (10.67%), comparing to 0.47% for members. The purchase frequency calculated by averaging the total orders is higher for non-members (1.14), comparing to 1.01 for members. This suggests that many customers may be joining the loyalty program solely to take advantage of some one-time offer like discounts, without remaining engaged with the company.

Based on the analysis, TechNova’s loyalty program is failing to drive long-term customer engagement or increase revenue. Instead of encouraging repeat purchases, it appears to attract deal-seekers who exploit one-time benefits without fostering sustained customer loyalty.

![Loyalty Program Analysis](https://github.com/user-attachments/assets/e2784a4b-e2de-4596-b583-db50695fd690)


### Marketing Channel
Among the 92,527 customers, only 4,902 are repeating customers while the average order value by returning customers ($422.34) is 1.7x higher than new customers ($250.16). 

The direct marketing channel is the most effective, generating the highest total sales ($17.48M) and the most orders (62,854) with a strong average order value (AOV) of $278.06. The null (unattributed) category follows with significant sales ($7.26M) and a comparable AOV ($256.94), suggesting a need to track its origin. Affiliate marketing has the highest AOV ($317.85), indicating high-value transactions despite lower order volume (2,102). Email marketing drives a decent number of orders (13,832) but has a relatively low AOV ($177.79), while social media contributes fewer orders (1,012) but maintains a moderate AOV ($234.64). Unknown sources have minimal impact. Improving attribution tracking and optimizing lower-performing channels could enhance overall effectiveness.

Social media performs well with a 68.92% conversion rate, suggesting strong engagement, though it takes the longest for users to make their first purchase (49.14 days). Affiliate marketing also has a high conversion rate (53.74%) but a slightly shorter time to first purchase (47.79 days). The null category has moderate performance (45.16% conversion rate) but slow conversion (52.32 days). Email marketing drives a large number of signups (13,356) but has a much lower 10.69% conversion rate, indicating potential drop-offs. Direct traffic, despite the highest number of signups (57,722), has the lowest conversion rate (2.53%), suggesting that while many users visit directly, few convert, or they take a different path to conversion.

![Marketing Channel](https://github.com/user-attachments/assets/789826ed-9972-4f52-8765-dfe5e5f1fa48)

## Recommendations

### Refund 
- Improve product descriptions and quality control for high-value products to lower return rates and investigate high laptop return rates, especially in NA and APAC, and adjust policies or support.
- Refine social media marketing to reduce impulse purchases and misinformation.
- Promote mobile app purchases, as they result in fewer refunds.

### Loyalty Program
Instead of rewarding new members with discounts, introduce tier-based loyalty program to enhance customer loyalty. 
- **Basic Members**: Get free shipping after 2 purchases.
- **Gold Members**: Earn cashback or discounts on their 3rd+ purchase.
- **Platinum Members**: Get exclusive early access to new products.

### Marketing Channel
1. Boost Retention – Repeat buyers (5.3%) spend 1.7x more. Use offers and retargeting to increase repeat purchases.
2. Improve Direct Traffic Conversions – Despite highest sales ($17.48M), conversion is low (2.53%). Optimize UX, checkout, and retargeting.
3. Enhance Tracking – $7.26M in unattributed sales. Use UTM tags & CRM integration for better insights.
4. Leverage Affiliates – Highest AOV ($317.85) but low volume. Expand partnerships and offer better incentives.
5. Optimize Email & Social Media – Email (10.69% conversion) needs better automation. Social media (68.92% conversion) needs urgency-driven promotions.
6. Speed Up First Purchases – Shorten 47+ day lag for affiliate & social media buyers with discounts and flash sales.

##### NOTE
- For every column, less than 3% is null. Thus, the impact is negligible.
- Please find the SQL queries for more details
