import 'package:flutter/material.dart';
import '../../services/settings_store.dart';

class SensitivityScreen extends StatefulWidget { const SensitivityScreen({super.key}); @override State<SensitivityScreen> createState()=>_SensitivityScreenState(); }
class _SensitivityScreenState extends State<SensitivityScreen>{ double _speed=1.0; double _dwell=0.9;
  @override void initState(){ super.initState(); _load(); }
  Future<void> _load() async { _speed = await SettingsStore.loadSpeed(); _dwell = await SettingsStore.loadDwell(); setState((){}); }
  @override Widget build(BuildContext c){ return Scaffold(appBar: AppBar(title: const Text('Adjust Sensitivity')), body: Padding(padding: const EdgeInsets.all(16), child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children:[
    const Align(alignment: Alignment.centerLeft, child: Text('Cursor Speed', style: TextStyle(fontWeight: FontWeight.w700))), Slider(min:0.5,max:2.0,value:_speed,onChanged:(v)=>setState(()=>_speed=v)),
    const SizedBox(height:12),
    const Align(alignment: Alignment.centerLeft, child: Text('Dwell / Click Hold (seconds)', style: TextStyle(fontWeight: FontWeight.w700))), Slider(min:0.5,max:1.5,divisions:10,value:_dwell,onChanged:(v)=>setState(()=>_dwell=v)),
    const SizedBox(height:12),
    FilledButton(onPressed: () async { await SettingsStore.saveSpeed(_speed); await SettingsStore.saveDwell(_dwell); if (!mounted) return; Navigator.pop(c); }, child: const Text('Save')),
  ]))))); }
}
