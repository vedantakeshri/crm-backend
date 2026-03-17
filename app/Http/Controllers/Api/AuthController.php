<?php

namespace App\Http\Controllers\Api;
use App\Models\User;
use Illuminate\Support\Facades\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class AuthController extends Controller
{
    // ✅ LOGIN API
    public function login(Request $request)
    {
        // 1. Validate request
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|min:6'
        ]);

        // 2. Attempt login
        if (!Auth::attempt($request->only('email', 'password'))) {
            return response()->json([
                'status' => false,
                'message' => 'Invalid email or password'
            ], 401);
        }

        // 3. Get user
        $user = Auth::user();

        // 4. Generate token (Sanctum)
        $token = $user->createToken('authToken')->plainTextToken;

        // 5. Return response
        return response()->json([
            'status' => true,
            'message' => 'Login successful',
            'token' => $token,
            'user' => $user
        ], 200);
    }


public function register(Request $request)
{
    $request->validate([
        'full_name' => 'required|string|max:255',
        'email' => 'required|email|unique:users,email',
        'password' => 'required|min:6|confirmed'
    ]);

    $user = User::create([
        'name' => $request->full_name, // ✅ map full_name → name
        'email' => $request->email,
        'password' => bcrypt($request->password),
    ]);

    $token = $user->createToken('authToken')->plainTextToken;

    return response()->json([
        'status' => true,
        'message' => 'User registered successfully',
        'token' => $token,
        'user' => $user
    ], 201);
}
}