class PitchData {
  int sampleRate;
  int bufferSize;

  PitchData(this.sampleRate,
      this.bufferSize,);

  static PitchData fromJson(Map<String, dynamic> json) =>
      PitchData(
        json['sampleRate'],
        json['bufferSize'],
      );
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sampleRate'] = this.sampleRate;
    data['bufferSize'] = this.bufferSize;
    return data;
  }
}
