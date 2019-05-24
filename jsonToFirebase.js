const firebase = require("firebase");
var recipesJSON = require('./recipes.json');
// Required for side-effects
require("firebase/firestore");

// Initialize Cloud Firestore through Firebase
firebase.initializeApp({
    apiKey: "AIzaSyC3bOf9SBDgw6PvFU8itqQ54LNv-VUax98",
    authDomain: "sous-chef-149504.firebaseapp.com",
    projectId: "sous-chef-149504"
  });
  
var db = firebase.firestore();

var recipes = recipesJSON.recipes;

recipes.forEach((recipe) => {
    db.collection("recipes").add({
        title: recipe.title,
        description: recipe.description,
        prepTime: recipe.prepTime,
        cookTime: recipe.cookTime,
        yeild: recipe.yeild,
        ingredients: recipe.ingredients,
        directions: recipe.directions,
        image: recipe.image,
    }).then((docRef) => {
        console.log("Document written with ID: ", docRef.id);
    })
    .catch((error) => {
        console.error("Error adding document: ", error);
    });
});