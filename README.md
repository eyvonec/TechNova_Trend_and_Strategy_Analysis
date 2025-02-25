# TechNova Trend and Strategy Analysis
Founded in 2018, TechNova is a global e-commerce company specializing in electronics and tech products. Initially focused on online sales, Technova has expanded its reach through both its website and mobile app, catering to a diverse international customer base.

To acquire and retain customers, Technova leverages a mix of marketing channels, including email campaigns, social media, SEO, and affiliate partnerships. The company has built a strong reputation for offering premium and high-demand tech products, particularly from Apple, Samsung, and ThinkPad, among others.

## Executive Summary
[TechNova’s sales peak in Nov-Dec but decline post-holidays. APAC shows premium potential with the highest AOV, while logistics inefficiencies in APAC & EMEA need optimization. High-value products and social media-driven sales drive the most refunds, despite social meida has the highest conversion rate, implying potential impulsive purchasing. The loyalty program fails to drive retention, with 99.53% of members making only one purchase. As returning customers generate higher average order value, there is a need to change loyalty program policy to increase returning customers. In addition, marketing should focus on social media (higher conversion rate) and affiliate program, which generates highest average order value. ]

## Deep Dive Insights
### Overview
Between 2019 and 2022, the dataset records 108K orders and $28M in sales. TechNova serves customers from 193 countries and offers a portfolio of 8 electronic product categories, including laptops, monitors, and headphones. 

### Trend Analysis
In March 2020, a pronounced spike suggests a pandemic-driven surge in demand—particularly for items like monitors, headphones, and laptops—while a significant dip in October 2022 may reflect market shifts or economic pressures.

![Monthly total sales trend per product](https://github.com/user-attachments/assets/b477edb6-e7bc-49f0-a235-7fb305b31d67)

Seasonal trends are evident, with November and December consistently recording the highest growth (likely due to holiday shopping) followed by a downturn in the surrounding months.

Comparing total sales, order count, and average order value (AOV) reveals that sales and order counts generally correlate. However, AOV sometimes diverges, indicating periods when customers favor higher-value purchases.

Additionally, the data shows that 2019 and 2020 experienced more prominent growth spikes, whereas 2021 and 2022 saw more frequent declines. This shift could be attributed to factors such as post-pandemic market saturation, inflation, or the inherently less frequent nature of electronics purchases compared to essentials.

![Monthly Growth Rate 2019-2022](https://github.com/user-attachments/assets/b269e10b-dec3-460d-a5bb-73721f0f4ca6)


### Geographic Distribution
TechNova's total sales are primarily concentrated in English-speaking countries, with the U.S. leading, followed by Great Britain and Canada. Although the overall sales distribution remained consistent from 2019 to 2022, the pandemic year of 2020 saw an increase in total sales across the top 10 countries (especially US had total sales over $3M USD), reflecting a global surge in demand for electronic devices.

![Sheet 3](https://github.com/user-attachments/assets/845291a5-d4ff-4559-bd1d-051c280ab859)

Regionally, North America records the highest total orders, followed by EMEA, APAC, and LATAM, while EMEA boasts the highest average order value (AOV), outpacing APAC, North America, and LATAM. Given that most customers currently come from North America, TechNova should consider expanding further into the EMEA market to capture high-value clientele.

![Sheet 2-3](https://github.com/user-attachments/assets/6558c683-6bdb-4c20-8e4a-5558a2f79eed)


### Logistics 
On average, orders take 7.51 days from purchase to delivery—2.01 days for processing and 5.5 days for shipping. Regional variations are minimal, especially in the shipment-to-delivery phase. Notably, in 2019, APAC and EMEA experienced slightly longer order-to-shipment times compared to LATAM and North America; however, from 2020 onward, logistic efficiency has normalized across all four regions.

![Logistic Efficiency per Region from 2019 to 2022  ](https://github.com/user-attachments/assets/6b1a31c8-2b25-4179-bb91-6e327fe05eea)


### Refund Rate 
Between 2019 and 2021, laptops experienced a notably higher refund rate—likely due to their nature and price point. Interestingly, 2021 saw a significant drop in refunds compared to the previous two years. However, no refund data is available for 2022, leaving room for two interpretations: either improvements in product information and logistics have minimized customer regret, or the refund data for 2022 is simply missing.

Additionally, it’s worth noting that Bose Headphones recorded zero refunds across all four years. This exceptional performance invites further investigation into the factors driving such positive results.

![Refund Count per Product from 2019 to 2022](https://github.com/user-attachments/assets/ae5c142e-2b13-49c5-b6e0-51ea5fdc9dcc)

![Refund Rate per Product from 2019 to 2022 ](https://github.com/user-attachments/assets/c6271eeb-05d3-42db-90bd-0072717bd8ad)


### Loyalty Program
Among the 32,501 loyalty members, the customer lifetime value (CLV), which evaluates how valuable a customer is over time , is significantly lower than non-members, averaging only $242.75, compared to $313.37 for non-members. This indicates that loyalty members do not contribute as much long-term value as expected.

Additionally, loyalty members have fewer total orders (32,789) and average order value ($240.62) compared to non-members (48,071; $274.66). Members also exhibit a refund rate of 6.39%, which is higher than non-members (4.16%).  Across 2019 to 2021 (2022 didn't have any refund), all the members had higher refund rate, especially in 2020, members had 13% refund while non-members only had 7%, indicating that a positive correlation between loyalty program and refund rate. 

Surprisingly, the customers who purchases headphones and webcams tend to join the loyalty program (more than 55% join rate), especially in 2022 customers who bought Bose Headphones all join the loyalty program. 

The most concerning trend is that 99.53% of loyalty members make only a single purchase while the repeat purchase rate for non-members is 23x higher (10.67%), comparing to 0.47% for members. The purchase frequency calculated by averaging the total orders is higher for non-members (1.14), comparing to 1.01 for members. This suggests that many customers may be joining the loyalty program solely to take advantage of some one-time offer like discounts, without remaining engaged with the company.

Based on the analysis, TechNova’s loyalty program is failing to drive long-term customer engagement or increase revenue. Instead of encouraging repeat purchases, it appears to attract deal-seekers who exploit one-time benefits without fostering sustained customer loyalty.

![Repeat Purchase Rate  ](https://github.com/user-attachments/assets/7ad13329-5a73-4e83-b717-9200a63f8b32)


### Marketing Channel
Among the 92,527 customers, only 4,902 are repeating customers while the average order value by returning customers ($422.34) is 1.7x higher than new customers ($250.16). 

The direct marketing channel is the most effective, generating the highest total sales ($17.48M) and the most orders (62,854) with a strong average order value (AOV) of $278.06. The null (unattributed) category follows with significant sales ($7.26M) and a comparable AOV ($256.94), suggesting a need to track its origin. Affiliate marketing has the highest AOV ($317.85), indicating high-value transactions despite lower order volume (2,102). Email marketing drives a decent number of orders (13,832) but has a relatively low AOV ($177.79), while social media contributes fewer orders (1,012) but maintains a moderate AOV ($234.64). Unknown sources have minimal impact. Improving attribution tracking and optimizing lower-performing channels could enhance overall effectiveness.

The conversion rate per market channel does not vary a lot across the years. However, affiliate program performed the best (100%) compared to the social meida (ranked the 2nd), direct, and email. In 2020, all the marketing channels perform worse than the other 4 years, which might be relate to the chaos caused by the pandemic when marketing activities might reduced. 

![Conversion rate per marketing channel](https://github.com/user-attachments/assets/5551cb81-88ef-41b7-95f4-a438465ad097)


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
