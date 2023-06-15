resource "google_compute_reservation" "zenotta-mining-reservation-zone-a" {
  name = "zenotta-mining-reservation-zone-a"
  zone = "us-central1-a"

  specific_reservation {

    count = 2
    instance_properties {

      machine_type = "g2-standard-16"

      guest_accelerators {
        accelerator_type  = "nvidia-l4"
        accelerator_count = 1
      }

    }

  }

  share_settings {
    share_type = "SPECIFIC_PROJECTS"
    project_map {
      id = "projects/${var.projectId}"
    }
  }

}

resource "google_compute_reservation" "zenotta-mining-reservation-zone-b" {
  name = "zenotta-mining-reservation-zone-a"
  zone = "us-central1-b"

  specific_reservation {

    count = 2
    instance_properties {

      machine_type = "g2-standard-16"

      guest_accelerators {
        accelerator_type  = "nvidia-l4"
        accelerator_count = 1
      }

    }

  }

  share_settings {
    share_type = "SPECIFIC_PROJECTS"
    project_map {
      id = "projects/${var.projectId}"
    }
  }

}

resource "google_compute_region_commitment" "zenotta-mining-commitment" {

  name     = "zenotta-mining-commitment"
  plan     = "TWELVE_MONTH"
  type     = "GRAPHICS_OPTIMIZED_G2"
  category = "MACHINE"
  region   = var.region

  depends_on = [
    google_compute_reservation.zenotta-mining-reservation-zone-a,
    google_compute_reservation.zenotta-mining-reservation-zone-b
  ]

  resources {
    type   = "VCPU"
    amount = "64"
  }
  resources {
    type   = "MEMORY"
    amount = "256"
  }
  resources {
    type             = "ACCELERATOR"
    amount           = "4"
    accelerator_type = "nvidia-l4"
  }
}
