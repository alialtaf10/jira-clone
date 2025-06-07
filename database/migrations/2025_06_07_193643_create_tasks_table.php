<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('tasks', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->text('description')->nullable();
            $table->foreignId('feature_id')->constrained()->onDelete('cascade');
            $table->foreignId('assigned_to')->nullable()->constrained('users');
            $table->string('status')->default('todo');
            $table->integer('priority')->default(0);
            $table->integer('estimated_hours')->nullable();
            $table->integer('actual_hours')->nullable();
            $table->date('due_date')->nullable();
            $table->date('completed_at')->nullable();
            $table->timestamps();
            $table->foreignId('created_by')->constrained('users')->after('created_at');
            $table->foreignId('updated_by')->nullable()->constrained('users')->after('updated_at');
        });
    }

    public function down()
    {
        Schema::dropIfExists('tasks');
    }
};
