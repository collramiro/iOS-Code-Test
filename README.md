# Code Challenge

## Instructions:

Please clone the repository, complete the exercise, and submit a PR for us to review! If you have any questions, you can reach out directly here or leave comments on your pull request which we will respond to. Remember, all instructions for running the application (including installing relevant libraries, etc.) should be included in the README. 


## Delivery Steps: 

1. Create a branch from `master` named `base` and push all the third-party code needed (Libraries, Frameworks, etc.).
2. Create a branch from `base` named `code-test` and push your own code (Remember to update the Readme file providing any instructions on how to run the project if needed).
3. Create a Pull Request from `code-test` to `base` for us to review.


## Please answer the following questions once you finish codding:

A) Describe the strategy used to consume the API endpoints and the data management.

To consume the API endpoints I used Alamofire5 (beta version). If you check the two models, you'll notice that I used different approachs to parse the data. At Drink model, I used the new Codable Swift object, that gives you a super easy and quick way to parse JSON response into models. For the DrinkDetail, I used standard dict parsing to fetch properly the N ingredients.

B) Explain which library was used for the routing and why. Would you use the same for a consumer facing app targeting thousands of users? Why?

I used a different approach for navigation in the app basing myself in a demo proyect. Using advanced transitions I copied the navigation from AppStore, using UIViewControllerTransitioningDelegate to achive it.

C) Have you used any strategy to optimize the performance of the list generated for the first feature?

Yes, I'm fetching each drink detail at the willDisplay delegate of the collectionview and requesting it from API asynchronously. Also, I'm caching the models into an array during the applife time, so we only need to fetch it once. If you perform a pull to request at the collectionview, all data will be refreshed from server. Anyway, this can be a lot better with a better API.

D) Would you like to add any further comments or observations?

The API haves a really poor design. It can be improved in a lot of different ways, for example:
	- Having all the data that we need at home screen at the first request.
	- Using pagination
	- Using timestamps to keep track of changes in data. In this way, we can use a database that can keep record of all drinks and just update some if is necessary.

## Overview:

Implement a simple mobile cocktails catalogue (master / detail). The catalogue consists of a table view list of cocktails with their name, toppings and photo. Once the user taps on a specific row it will push a new screen with that drink’s details: Name, Photo, Ingredients and Preparation.


## Features:

**1. Cocktails list:**

For each row of the list it will display the Cocktail name, photo and ingredients (See wireframe 1). 
In the case where there are more than 2 ingredients, add a label that reads "y X ingredientes más" where `X` is the amount of extra ingredients.

The API endpoint that has the list of drinks with Name and Photo is: 

http://www.thecocktaildb.com/api/json/v1/1/filter.php?g=Cocktail_glass

This returns a JSON list of cocktails, and the information needed in order to populate each row of the list.

```
{
 	strDrink,           → Cocktail name
     	strDrinkThumb,  → Photo URL
      	idDrink       → Cocktail ID
}
```

You'll need to decide the approach to get the ingredients data that is not present on this endpoint. You can comment that approach and the implications inside the code and what can be done to improve this.

Wireframe 1:

![screen shot 2018-02-02 at 12 53 57](https://user-images.githubusercontent.com/263229/35742087-40b1ce26-0818-11e8-91d7-5c2ea0d4a6aa.png)




**2. Cocktail detail:**

Once the user taps on a row from the list mentioned in the previous feature it will push a new screen with the selected cocktail’s details, where it will show it’s name, photo, ingredients (with the quantity on each case next to it) and instructions (See wireframe 2).

The endpoint to be used for this is the following:
 
http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=${idDrink} → Cocktail ID
I.g.: http://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=16108

The endpoint returns a JSON with the cocktails info, the needed properties are:
```
{
	strInstructions,  → instructions
	strDrink,         → cocktail name
	strDrinkThumb,    → photo URL
	strIngredient1,   → ingredient 1
	...
	strIngredientN    → ingredient N
}
```

Wireframe 2

![screen shot 2018-02-02 at 12 53 37](https://user-images.githubusercontent.com/263229/35742155-63205b1c-0818-11e8-8b4b-608a46eaa718.png)
	
  
  
  
**3. Bonus Points: (Optional)**

A) Implement a filter by name functionality on the first screen that automatically filters the results while typing, only showing the rows that satisfy the criteria entered by the user.

B) Include test coverage for the most relevant functionalities.

Thank you and looking forward to seeing your great work!



