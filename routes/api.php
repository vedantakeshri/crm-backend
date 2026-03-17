<?php

use App\Http\Controllers\Api\AuthController;
use Illuminate\Support\Facades\Route;

// Test route
Route::post('/login', [AuthController::class, 'login']);

Route::post('/register', [AuthController::class, 'register']);
