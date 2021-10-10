using System.Collections;
using System.Collections.Generic;
using UnityEngine;

interface IElastic
{
    void OnElastic(RaycastHit hit);
}
[RequireComponent(typeof(MeshRenderer))]
public class BounceBall : MonoBehaviour,IElastic
{
    private static int _pos, _normal, _time;
    private MeshRenderer mesh;

    static BounceBall()
    {

        _pos = Shader.PropertyToID("_Position");

        _normal = Shader.PropertyToID("_Normal");

        _time = Shader.PropertyToID("_PointTime");

    }
    private void Awake()
    {
        mesh = GetComponent<MeshRenderer>();
    }
    public void OnElastic(RaycastHit hit)
    {
        Vector4 hitPos = transform.InverseTransformPoint(hit.point);
        hitPos.w = 0.6f;
        mesh.material.SetVector(_pos, hitPos);

        Vector4 normalDirect = transform.InverseTransformDirection(hit.normal.normalized);
        normalDirect.w = 0.2f;
        mesh.material.SetVector(_normal, normalDirect);
        mesh.material.SetFloat(_time, Time.time);
    }

    private void OnMouseDown()
    {
        var ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;
        if(Physics.Raycast(ray,out hit))
        {
            OnElastic(hit);
        }
    }
}
