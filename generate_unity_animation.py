#!/usr/bin/python3
import ruamel.yaml
from ruamel.yaml.comments import CommentedSeq, CommentedMap
import sys

yaml_str = """
%YAML 1.1
%TAG !u! tag:unity3d.com,2011:
--- !u!74 &7400000
AnimationClip:
  m_ObjectHideFlags: 0
  m_CorrespondingSourceObject: {fileID: 0}
  m_PrefabInstance: {fileID: 0}
  m_PrefabAsset: {fileID: 0}
  m_Name: Animation
  serializedVersion: 6
  m_Legacy: 0
  m_Compressed: 0
  m_UseHighQualityCurve: 1
  m_RotationCurves: []
  m_CompressedRotationCurves: []
  m_EulerCurves: []
  m_PositionCurves:
  - curve:
      serializedVersion: 2
      m_PreInfinity: 2
      m_PostInfinity: 2
      m_RotationOrder: 4
    path:
  m_ScaleCurves: []
  m_FloatCurves: []
  m_PPtrCurves: []
  m_SampleRate: 60
  m_WrapMode: 0
  m_Bounds:
    m_Center: {x: 0, 'y': 0, z: 0}
    m_Extent: {x: 0, 'y': 0, z: 0}
  m_ClipBindingConstant:
    genericBindings:
    - serializedVersion: 2
      path: 0
      attribute: 1
      script: {fileID: 0}
      typeID: 4
      customType: 0
      isPPtrCurve: 0
    pptrCurveMapping: []
  m_AnimationClipSettings:
    serializedVersion: 2
    m_AdditiveReferencePoseClip: {fileID: 0}
    m_AdditiveReferencePoseTime: 0
    m_StartTime: 0
    m_StopTime: 0.8666667
    m_OrientationOffsetY: 0
    m_Level: 0
    m_CycleOffset: 0
    m_HasAdditiveReferencePose: 0
    m_LoopTime: 1
    m_LoopBlend: 0
    m_LoopBlendOrientation: 0
    m_LoopBlendPositionY: 0
    m_LoopBlendPositionXZ: 0
    m_KeepOriginalOrientation: 0
    m_KeepOriginalPositionY: 1
    m_KeepOriginalPositionXZ: 0
    m_HeightFromFeet: 0
    m_Mirror: 0
  m_EditorCurves:
  - curve:
      serializedVersion: 2
      m_PreInfinity: 2
      m_PostInfinity: 2
      m_RotationOrder: 4
    attribute: m_LocalPosition.x
    path:
    classID: 4
    script: {fileID: 0}
  - curve:
      serializedVersion: 2
      m_PreInfinity: 2
      m_PostInfinity: 2
      m_RotationOrder: 4
    attribute: m_LocalPosition.y
    path:
    classID: 4
    script: {fileID: 0}
  - curve:
      serializedVersion: 2
      m_PreInfinity: 2
      m_PostInfinity: 2
      m_RotationOrder: 4
    attribute: m_LocalPosition.z
    path:
    classID: 4
    script: {fileID: 0}
  m_EulerEditorCurves: []
  m_HasGenericRootTransform: 1
  m_HasMotionFloatCurves: 0
  m_Events: []
"""

def D(d):
   ret = ruamel.yaml.comments.CommentedMap(d)
   ret.fa.set_flow_style()
   return ret

m_PositionCurve = {
    'serializedVersion' : 3,
    'time' : 0,
    'tangentMode' : 0,
    'weightedMode' : 0,
    'inSlope' : D({'x' : 0, 'y' : 0, 'z' : 0}),
    'outSlope' : D({'x' : 0, 'y' : 0, 'z' : 0}),
    'inWeight' : D({'x' : 0.33333334, 'y' : 0.33333334, 'z' : 0.33333334}),
    'outWeight' : D({'x' : 0.33333334, 'y' : 0.33333334, 'z' : 0.33333334})
}

m_EditorCurve = {
    'serializedVersion' : 3,
    'inSlope' : 0,
    'outSlope' : 0,
    'tangentMode' : 136,
    'weightedMode' : 0,
    'inWeight' : 0.33333334,
    'outWeight' : 0.33333334
}

class NonAliasingRTRepresenter(ruamel.yaml.RoundTripRepresenter):
    def ignore_aliases(self, data):
        return True

def my_represent_none(self, data):
    return self.represent_scalar(u'tag:yaml.org,2002:null', u'')

yml = ruamel.yaml.YAML()
yml.Representer = NonAliasingRTRepresenter
yml.representer.add_representer(type(None), my_represent_none)
yml.preserve_quotes = False

data = yml.load(yaml_str)

data['AnimationClip']['m_PositionCurves'][0]['curve']['m_Curve'] = []

data['AnimationClip']['m_EditorCurves'][0]['curve']['m_Curve'] = []
data['AnimationClip']['m_EditorCurves'][1]['curve']['m_Curve'] = []
data['AnimationClip']['m_EditorCurves'][2]['curve']['m_Curve'] = []

time = 0;
for index in range(0, 100000, 1):
    time = index/10.0
    m_PositionCurve['value'] = D({'x' : time, 'y' : time, 'z' : 1})
    m_PositionCurve['time']  = time
    data['AnimationClip']['m_PositionCurves'][0]['curve']['m_Curve'].append(m_PositionCurve.copy())
    m_EditorCurve['value'] = time
    m_EditorCurve['time'] = time
    data['AnimationClip']['m_EditorCurves'][0]['curve']['m_Curve'].append(m_EditorCurve.copy())
    data['AnimationClip']['m_EditorCurves'][1]['curve']['m_Curve'].append(m_EditorCurve.copy())
    data['AnimationClip']['m_EditorCurves'][2]['curve']['m_Curve'].append(m_EditorCurve.copy())

data['AnimationClip']['m_AnimationClipSettings']['m_StopTime'] = time

yml.dump(data, sys.stdout)
