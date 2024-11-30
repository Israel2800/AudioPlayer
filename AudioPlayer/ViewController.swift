//
//  ViewController.swift
//  AudioPlayer
//
//  Created by Paola Delgadillo on 11/29/24.
//

import UIKit
import AVKit
import AVFoundation
import YouTubeiOSPlayerHelper

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    let btnPlay = UIButton(type: .system)
    let btnStop = UIButton(type: .system)
    let sliderDuration = UISlider()
    let sliderVolume = UISlider()
    var imgContainer : UIImageView!
    var audioPlayer: AVAudioPlayer!
    var timer: Timer!
    
    // Para cargar videos desde Youtube
    var youtubeView: YTPlayerView!

    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            let l1=UILabel()
            l1.text="AudioPlayer"
            l1.font=UIFont.systemFont(ofSize: 24)
            l1.autoresizingMask = .flexibleWidth
            l1.translatesAutoresizingMaskIntoConstraints=true
            l1.frame=CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50)
            l1.textAlignment = .center
            self.view.addSubview(l1)
            
            btnPlay.setTitle("Play", for: .normal)
            btnPlay.autoresizingMask = .flexibleWidth
            btnPlay.translatesAutoresizingMaskIntoConstraints=true
            btnPlay.frame=CGRect(x: 20, y: 100, width: 100, height: 40)
            self.view.addSubview(btnPlay)
            btnPlay.addTarget(self, action:#selector(btnPlayTouch), for: .touchUpInside)
            
            sliderDuration.autoresizingMask = .flexibleWidth
            sliderDuration.translatesAutoresizingMaskIntoConstraints=true
            sliderDuration.frame=CGRect(x: 20, y:150, width: self.view.frame.width-40, height: 50)
            self.view.addSubview(sliderDuration)
            sliderDuration.addTarget(self, action:#selector(sliderDurationChange), for:.valueChanged)
            
            btnStop.setTitle("Stop", for: .normal)
            btnStop.autoresizingMask = .flexibleWidth
            btnStop.translatesAutoresizingMaskIntoConstraints=true
            btnStop.frame=CGRect(x:self.view.frame.width-100, y: 100, width: 100, height: 40)
            self.view.addSubview(btnStop)
            btnStop.addTarget(self, action:#selector(btnStopTouch), for:.touchUpInside)
            
            let l2=UILabel()
            l2.text="Volumen"
            l2.autoresizingMask = .flexibleWidth
            l2.translatesAutoresizingMaskIntoConstraints=true
            l2.frame=CGRect(x: 20, y: 200, width: 100, height: 40)
            self.view.addSubview(l2)

            sliderVolume.autoresizingMask = .flexibleWidth
            sliderVolume.translatesAutoresizingMaskIntoConstraints=true
            sliderVolume.frame=CGRect(x: 20, y: 250, width: self.view.frame.width/2, height: 50)
            self.view.addSubview(sliderVolume)
            sliderVolume.addTarget(self, action:#selector(sliderVolumeChange), for:.valueChanged)
            
            imgContainer = UIImageView(frame: CGRect(x: 0, y: 400, width: 240, height: 130))
            imgContainer.translatesAutoresizingMaskIntoConstraints=true
            imgContainer.center.x = self.view.center.x
            self.view.addSubview(imgContainer)
            cargarAudio()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cargarVideo()
    }
    
    func cargarVideo(){
        // Reproducción de videos desde YT
        //https://youtu.be/DoyA619L9MQ?si=FNcpifSl17qEEK_F0
        
        youtubeView = YTPlayerView(frame: self.imgContainer.frame)
        youtubeView.load(withVideoId: "DoyA619L9MQ")
        self.view.addSubview(youtubeView)
        
        
        /*
        // Reproducción de recursos de video
        let videoController = Reproductor()
        // Esto es fullscreen
        //self.present(videoController, animated: true) // Para presentar en full screen
        
        // Video incrustado
        videoController.view.frame = self.imgContainer.frame
        
        // Cuando agregamos la vista de un viewController como subview en otro viewController, no se agrupa la lógica de ejecución
        self.view.addSubview(videoController.view)
        
        // Para agregar la lógica de programación
        self.addChild(videoController)
        */
    }
    
    func cargarAudio(){
        guard let laURL = Bundle.main.url(forResource: "MUSIC3", withExtension: "mp3") else { return }
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: laURL)
            audioPlayer.delegate = self
            // Inicializar la interfaz
            inicializarInterfaz()
        }
        catch {
            print("No se pudo cargar el audio \(error.localizedDescription)")
        }
    }
    
    func inicializarInterfaz(){
        // Sincronizamos el volúmen inicial del audio con la posición inicial del slider
        audioPlayer.volume = 0.5
        sliderVolume.value = 0.5
        
        // El slider duración debe inicializar con el valor de la duración en segundos
        sliderDuration.maximumValue = Float(audioPlayer.duration)
        
        timer = Timer.scheduledTimer(withTimeInterval:1.0, repeats:true, block: { timer in
            self.sliderDuration.value = Float(self.audioPlayer.currentTime)
        })
        
        audioPlayer.numberOfLoops = -1 // Se reproduce indefinidamente
        audioPlayer.play()
    }
    
    @objc func btnPlayTouch(){
        // audioPlayer.currentTime = 0
        audioPlayer.play()
    }
    
    @objc func sliderDurationChange(){
        audioPlayer.currentTime = Double(sliderDuration.value)
    }
    
    @objc func btnStopTouch(){
        audioPlayer.stop()
    }
    
    @objc func sliderVolumeChange(){
        audioPlayer.volume = sliderVolume.value
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer.invalidate()
    }


}

