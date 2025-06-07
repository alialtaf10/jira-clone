<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('activity_logs', function (Blueprint $table) {
            $table->id();
            $table->string('log_name')->nullable();
            $table->text('description');
            $table->foreignId('causer_id')->nullable()->constrained('users');
            $table->morphs('subject'); // The model that was acted upon
            $table->json('properties')->nullable();
            $table->timestamps();
            $table->foreignId('created_by')->constrained('users')->after('created_at');
            $table->foreignId('updated_by')->nullable()->constrained('users')->after('updated_at');
        });
    }

    public function down()
    {
        Schema::dropIfExists('activity_logs');
    }
};
