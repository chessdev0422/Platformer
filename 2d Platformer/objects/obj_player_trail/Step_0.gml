alpha -= alpha_fade_amt;

if alpha <= 0
{
	instance_destroy();
}