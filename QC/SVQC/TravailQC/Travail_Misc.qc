// DRESK
// Travail Misc.

// Definitions

// Fields

// Functions
float Travail_orig_random()
{
	local float len;

	len = vlen (self.origin);

	return len - floor(len);
}