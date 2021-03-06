using UnityEngine;

namespace BehaviorDesigner.Runtime.Tasks.Basic.UnityParticleSystem
{
    [TaskCategory("Basic/ParticleSystem")]
    [TaskDescription("Sets the start color of the Particle System.")]
    public class SetStartColor : Action
    {
        [Tooltip("The GameObject that the task operates on. If null the task GameObject is used.")]
        public SharedGameObject targetGameObject;
        [Tooltip("The start color of the ParticleSystem")]
        public SharedColor startColor;

        private ParticleSystem particleSystem;
        private GameObject prevGameObject;

        public override void OnStart()
        {
            var currentGameObject = GetDefaultGameObject(targetGameObject.Value);
            if (currentGameObject != prevGameObject) {
                particleSystem = currentGameObject.GetComponent<ParticleSystem>();
                prevGameObject = currentGameObject;
            }
        }

        public override TaskStatus OnUpdate()
        {
            if (particleSystem == null) {
                Debug.LogWarning("ParticleSystem is null");
                return TaskStatus.Failure;
            }

#if UNITY_5_0 || UNITY_5_1 || UNITY_5_2 || UNITY_5_3 || UNITY_5_4
            particleSystem.startColor = startColor.Value;
#else
            ParticleSystem.MainModule mainParticleSystem = particleSystem.main;
            mainParticleSystem.startColor = startColor.Value;
#endif

            return TaskStatus.Success;
        }

        public override void OnReset()
        {
            targetGameObject = null;
            startColor = Color.white;
        }
    }
}