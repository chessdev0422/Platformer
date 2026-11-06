if (sprite_index == attackSpr1)
{
    isAttacking = false;
    currentCombo = 1;
    comboLostTimer = 0;
    afterAttackRecoveryTimer = afterAttackRecoveryFrames;
    canAttack = true;
}
else if (sprite_index == attackSpr2)
{
    isAttacking = false;
    currentCombo = 2;
    comboLostTimer = 0;
    afterAttackRecoveryTimer = afterAttackRecoveryFrames;
    canAttack = true;
}
else if (sprite_index == attackSprWide || sprite_index == attackSprUp || sprite_index == attackSprDown || sprite_index == attackSprJump)
{
    isAttacking = false;
    currentCombo = 0;
    finalAttackRecoveryTimer = finalAttackRecoveryFrames;
    canAttack = true;
}