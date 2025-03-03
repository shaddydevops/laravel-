<?php

use App\Http\Controllers\Api\AuthenticationController;
use App\Http\Controllers\Api\PasswordResetController;
use App\Http\Controllers\Api\UserController;
use Illuminate\Support\Facades\Route;

Route::get("health", function () {
    return response()->json([
        'status' => "ok"
    ]);
});

// Fixed routes (changed [class, ...] to [AuthenticationController::class, ...])
Route::post('login', [AuthenticationController::class, 'login']);
Route::post('logout', [AuthenticationController::class, 'logout'])->middleware('auth:sanctum');

// routes/api.php
Route::get('/test', function () {
    return response()->json(['status' => 'ok']);
});

Route::post('password/forgot', [PasswordResetController::class, 'forgotPassword']);
Route::post('password/reset', [PasswordResetController::class, 'resetPassword']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::patch("users/{user}/change-password", [AuthenticationController::class, "changePassword"]);
    Route::patch("users/{user}", [UserController::class, "update"]);

    Route::prefix('admin')->group(function () {
        Route::apiResource("users", UserController::class);
    });
});