#!/usr/bin/env python
# coding: utf-8

# In[1]:


import requests
# a very lightweight website
url = 'https://www.airbnb.com/lagos-nigeria/stays'
# Let's render it here (I love Jupyter)
from IPython.display import IFrame
IFrame(src=url, width='100%', height='250ps')
answer = requests.get(url)
# what could we do with an answer
print(answer.url)
print(answer.status_code)
print(answer.reason)
print(answer.content)


# In[2]:


from bs4 import BeautifulSoup
soup = BeautifulSoup(answer.content, 'html.parser')
# now we can recognize some structure
print(soup.prettify())
soup.title
# let's find the links
soup.find_all('a')[:10]
# and get the title of one
soup.find_all('a')[5].get_text()


# In[3]:


# Let's plan a trip to Austrian Alps
airbnb_url = 'https://www.airbnb.com/lagos-nigeria/stays'
soup = BeautifulSoup(requests.get(airbnb_url).content, 'html.parser')
print(soup.prettify())


# In[4]:


soup.find_all('div', '_1gw6tte')
# we can also extract its child tag
soup.find_all('div', '_1gw6tte')
listings = soup.find_all('div', '_1gw6tte')
listings[0]
listings[0].find_all('a')[0].get('href')
listings[0].get_text()


# In[9]:


# First Generation :)
def extract_basic_features(listing_html):
    features_dict = {}
    
    url = listing_html.find('a').get('href')
    name = listing_html.find("div", {"class": "hyt39vx t1ykgwt5 dir dir-ltr"}).get_text()
    header = listing_html.find("div", {"class": "hyt39vx t1ykgwt5 dir dir-ltr"}).get_text()
    
    features_dict['url'] = url
    features_dict['name'] = name
    features_dict['header'] = header
    
    return features_dict
extract_basic_features(listings[0])
# what if the tag is not found?
listings[0].find('b')

# Second Generation :)
def extract_basic_features(listing_html):
    features_dict = {}
    
    try:
        url = listing_html.find('b').get('href')
    except:
        url = 'empty'
    try:
        name = listing_html.find("div", {"class": "_hxt6u1e"}).get('aria-label')
    except:
        name = 'empty'
    try:
        header = listing_html.find("div", {"class": "_b14dlit"}).text
    except:
        header = 'empty'
           
    features_dict['url'] = url
    features_dict['name'] = name
    features_dict['header'] = header
    
    return features_dict
extract_basic_features(listings[0])

# too many separate extractions
RULES_SEARCH_PAGE = {
    'url': {'tag': 'a', 'get': 'href'},
    'name': {'tag': 'div', 'class': '_hxt6u1e', 'get': 'aria-label'},
    'header': {'tag': 'div', 'class': '_b14dlit'},
    'rooms': {'tag': 'div', 'class': '_kqh46o'},
    'facilities': {'tag': 'div', 'class': '_kqh46o', 'order': 1},
    'badge': {'tag': 'div', 'class': '_17bkx6k'},
    'rating_n_reviews': {'tag': 'span', 'class': '_18khxk1'},
    'price': {'tag': 'span', 'class': '_1p7iugi'},
    'superhost': {'tag': 'div', 'class': '_ufoy4t'},
}


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




