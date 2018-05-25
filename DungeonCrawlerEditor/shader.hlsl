struct VOut
{
	float4 position : SV_POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

Texture2D texture0;
SamplerState sampler0;

cbuffer CBuffer0
{
	matrix WVPMatrix;
	float1 WorldTransformationEnabled;
	float1 Highlight;
	float2 PackingBytes;
};

VOut VShader(float4 position : POSITION, float4 color : COLOR, float2 texcoord : TEXCOORD)
{
	VOut output;

	//This constant buffer uses float values even though bools would be enough.
	//Floats have the advantage of filling the neccessary packing space the constant buffer requests

	//calculates world transformation if the attribute is set
	if (WorldTransformationEnabled > 0.0f)
	{
		output.position = mul(WVPMatrix, position);
	}
	else
	{
		output.position = position;
	}
	
	//changes the color of the vertices to green or red when they need to be highlighted in such a way
	if (Highlight > 0.0f && Highlight < 25.0f)
	{
		float4 red = { 1.0f, 0.0f, 0.0f, 1.0f };
		output.color = red;
	}
	else if(Highlight > 25.0f && Highlight < 75.0f)
	{
		float4 green = { 0.0f, 1.0f, 0.0f, 1.0f };
		output.color = green;
	}
	else if (Highlight > 75.0f)
	{
		output.color = color;
	}
	
	output.texcoord = texcoord;

	return output;
}

float4 PShader(float4 position : SV_POSITION, float4 color : COLOR, float2 texcoord : TEXCOORD) : SV_TARGET
{
	return color * texture0.Sample(sampler0, texcoord);
}