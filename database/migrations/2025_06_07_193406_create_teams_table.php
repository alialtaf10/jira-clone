<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('teams', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->text('description')->nullable();
            $table->foreignId('team_lead_id')->constrained('users');
            $table->timestamps();
            $table->foreignId('created_by')->constrained('users')->after('created_at');
            $table->foreignId('updated_by')->nullable()->constrained('users')->after('updated_at');
        });
    }

    public function down()
    {
        Schema::dropIfExists('teams');
    }
};
