import 'package:flutter/material.dart';
import '../../services/settings_store.dart';

class SoundScreen extends StatefulWidget { const SoundScreen({super.key}); @override State<SoundScreen> createState()=>_SoundScreenState(); }
class _SoundScreenState extends State<SoundScreen>{ bool _enabled=true; double _interval=0.8;
  @override void initState(){ super.initState(); _load(); }
  Future<void> _load() async { _enabled = await SettingsStore.loadSound(); setState((){}); }
  @override Widget build(BuildContext c){ return Scaffold(appBar: AppBar(title: const Text('Sound Settings')), body: Padding(padding: const EdgeInsets.all(16), child: Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children:[
    SwitchListTile(value:_enabled,onChanged:(v)=>setState(()=>_enabled=v), title: const Text('Enable Sound Effect', style: TextStyle(fontWeight: FontWeight.w700))),
    const SizedBox(height:12), const Align(alignment: Alignment.centerLeft, child: Text('Eye-Closing Sound Interval (visual only in this build)')),
    Slider(min:0.3,max:1.5,value:_interval,onChanged:(v)=>setState(()=>_interval=v)),
    const SizedBox(height:12),
    FilledButton(onPressed: () async { await SettingsStore.saveSound(_enabled); if (!mounted) return; Navigator.pop(c); }, child: const Text('Save')),
  ]))))); }
}
