Shader "Luzzy/DynamicEffects/Desertification"
{
    Properties
    {
        _MainTex ("BaseTexture",2D) = "white"{}
        _InitSpeed("Init Speed",Float) = 0
        _Acceleration("Acceleration",float) =5
        _Duration("Duration",int) = 2
        _Color("Color",Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags
        {
            "rendertype"="opaque"
        }
        
        pass
        {
            CGPROGRAM

            #pragma vertex vert
            #pragma geometry geom
            #pragma fragment frag 

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _InitSpeed;
            float _Acceleration;
            float _Duration;
            fixed4 _Color;

            struct appdata{
                float4 vertex:POSITION;
                float2 uv :TEXCOORD0;
            };

            struct v2g{
                float4 vertex:POSITION;
                float2 uv:TEXCOORD0;
            };

            struct g2f{
                float4 vertex:SV_POSITION;
                float2 uv:TEXCOORD0;
            };

            v2g vert(appdata a)
            {
                v2g o;
                o.vertex= a.vertex;
                o.uv = a.uv;
                return o;
            }

            [maxvertexcount(1)]
            void geom(triangle v2g IN[3],inout PointStream<g2f> pointStream)
            {
                g2f o;

                float3 v1 = IN[1].vertex - IN[0].vertex;
                float3 v2 = IN[2].vertex - IN[0].vertex;

                float3 normal = normalize(cross(v1,v2));
                float3 pos = (IN[0].vertex +IN[1].vertex + IN[2].vertex)/3;

                float time = _Time.y % _Duration;
                pos += normal*(_InitSpeed*time+0.5*_Acceleration*pow(time,2));

                o.vertex = UnityObjectToClipPos(pos);

                o.uv = (IN[0].uv +IN[1].uv + IN[2].uv)/3;

                pointStream.Append(o);
            }
        
            fixed4 frag(g2f g):SV_TARGET
            {
                fixed4 color = tex2D(_MainTex,g.uv)*_Color;
                return color;
            }

            ENDCG
        }
    }
}
