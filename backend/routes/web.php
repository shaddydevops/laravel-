<?php
use Illuminate\Support\Facades\Route;

// Route for "/"
Route::get('/', function () {
    return view('index'); // Replace 'welcome' with your actual view name
});

// Route for "/health"
Route::get('/health', function () {
    return response()->json(['status' => 'ok']);
});

// Login redirect
Route::get('login', function () {
    return redirect('/');
})->name('login');